=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

# == Schema Information
#
# Table name: networks
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_id         :integer
#  sales           :integer          default(0)
#  satisfaction    :decimal(, )      default(0.0)
#  total_profit    :decimal(20, 2)   default(0.0)
#  risk_mitigation :integer          default(0)
#  risk_id         :integer
#  score           :decimal(, )      default(0.0)
#

#Network is a group of companies working together
#Creating a network is main objective of round 2

class Network < ActiveRecord::Base
  has_many :companies
  has_many :network_reports

  belongs_to :risk





  


  #Returns an array containing all the companies in the network the customer_facing_role belongs to
  def self.get_network(customer_facing_role)
    companies = []
    company= customer_facing_role.company
    if !company.part_of_network
      return []
    end
    companies << company
    company.suppliers.each do |o|
      if o.part_of_network
        companies << o
        o.suppliers.each do |s|
          companies << s
        end
      end
    end
    return companies
  end


 

  #Returns the sell price of the customer facing company in the network
  def sell_price
    self.customer_facing.role.sell_price
  end


  
 

  #Static method used to calculate score for all networks in the game
  #Currently uses the revenue from the sales as the score
  def self.calculate_score
    nets = Network.all
    nets.each do |n|
      total = 0
      n.companies.each do |c|
        total += c.profit
      end
      n.total_profit += total
      n.score += n.customer_facing.revenue
      n.save!
    end
  end

  #Gets the position of a network in the ranking list
  def get_position
    nets = Network.order("score DESC")
    nets.each_with_index do |n, i|
      if n == self
        return i+1
      end
    end
    return -1
  end



  #Returns tjhe maximum amount of launches this network can perform
  def max_capacity
    max = nil
    companies.each do |c|
      if !max || max > c.max_capacity
        max = c.max_capacity
      end
    end
    max
  end

  def self.reset_sales
    Network.all.each do |n|
      n.sales = 0
      n.save!
    end
  end

  #Adds revenue from the sales to all companies in network for all networks
  # The customer-facing company gets profit from sales made, while other
  # companies get profit from launches based on contract
  def self.calculate_revenue
    Network.all.each do |n|
      n.companies.each do |c|
        if c.is_customer_facing? && !c.role.sell_price.nil?
          c.revenue = c.role.sell_price * n.sales
          c.save!
        else
          launches = n.get_launches
          c.revenue = c.contract_revenue * launches
          c.save!
        end
      end
    end
  end

  def self.get_network_satisfaction(company)
    total = 0.0
    companies = company.get_network
    market = company.role.market
    companies.each do |o|
      if total == 0.0
        total = o.get_satisfaction(market)
      else
        total *= o.get_satisfaction(market)
      end
    end
    return [total, 1.5].min
  end

  #Returns the weighted customer satisfaction value that considers the last years customer satisfaction based on some weight
  #Params:
  #customer_role: The CustomerFacingRole of the company owning the network
  def self.get_weighted_satisfaction(customer_role, sell_price=nil)
    
    bonus_sat = customer_role.bonus_satisfaction
    bonus_sat = 0 if bonus_sat == nil
 
    last_sat = (customer_role.last_satisfaction != nil) ? customer_role.last_satisfaction : bonus_sat

    

    sat = Network.get_network_satisfaction(customer_role.company).to_f

    
  
    counter_weight = customer_role.market.lb_satisfaction_weight.to_f
    

    weight = 1 - counter_weight
    

    exp1 = customer_role.market.variables["exp1"].to_f
    
    experience = customer_role.company.network_experience.to_f / 100 * exp1
    
    price = (sell_price == nil) ? customer_role.sell_price.to_f : sell_price
    

    new_sat = weight*(sat*([0.3, ([experience/price, 1].min)].max**2)) + last_sat*counter_weight
    

    customer_role.update_attribute(:last_satisfaction, new_sat)
    return new_sat
  end

  def self.test_network_satisfaction_weighted(customer_role, companies, market)

    last_sat = 0

    sat = Network.test_network_satisfaction(companies, market).to_f

    counter_weight = 0
    weight = 1 - counter_weight
    exp1 = market.variables["exp1"].to_f
    experience = Network.test_experience(companies).to_f / 100 * exp1
    price = customer_role.sell_price.to_f
    new_sat = weight*(sat*([0.3, ([experience/price, 1].min)].max**2)) + last_sat*counter_weight

    return new_sat
  end

  def self.test_network_satisfaction(companies, market)
    total = 0.0
    companies.each do |o|
      if total == 0.0
        total = o.get_satisfaction(market)
      else
        total *= o.get_satisfaction(market)
      end
    end
    return [total, 1.5].min
  end

  def self.test_experience(companies)
    experience = 0
    companies.each do |c|
      experience = c.role.experience if c.company_type.experience_produce?
    end
    return experience
  end

  def self.test_network_costs(companies)
    launches = companies.reject{ |c| !c.company_type.unit_produce? }.first.role.number_of_units
    capacity = companies.reject{ |c| !c.company_type.capacity_produce? }.first.role.unit_size
    costs = {}
    costs["total_capacity"] = launches * capacity
    total = 0
    companies.each do |c|
      fixed_cost = c.fixed_sat_cost + c.marketing_cost + c.capacity_cost + c.unit_cost + c.experience_cost
      variable_cost = c.variable_cost * launches
      total_cost = fixed_cost + variable_cost
      total += total_cost
      costs[c.name] = total_cost.round
    end
    costs["total"] = total.round
    return costs
  end

  #Calculates the market share for this network
  def calculate_market_share
    if self.customer_facing.role.market.nil? || self.customer_facing.role.market.total_sales == 0
      return 0
    else
      m = self.customer_facing.role.market
      total = m.total_sales
      exact_share = self.sales.to_f / total.to_f
      appro_share = ((exact_share*10).round) * 10
      return appro_share
    end
  end

  def self.relation_array(company, year=nil)
    relations = []
    puts "Given year: #{year}"
    network = company.get_network(year)
    network.each do |c|
      partners = c.suppliers + c.buyers
      partners.each do |p|
        relation = [c.id, p.id].sort
        relations << relation unless relations.include? relation
      end
    end
    relations
  end

private

  
  
  
end
