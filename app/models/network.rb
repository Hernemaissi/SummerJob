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

  def create_report
    report = self.network_reports.create
    report.year = Game.get_game.sub_round - 1
    report.customer_revenue = self.customer_facing.revenue
    report.sales = self.sales
    report.satisfaction = self.satisfaction
    report.max_launch = self.max_capacity
    report.performed_launch = self.get_launches
    report.net_cost = self.calculate_net_cost(report.year)
    report.save!
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

  #Calculates the net cost of the network (fixed cost and customer_satiscfaction cost for all companies) for
  # the year given as a parameter
  def calculate_net_cost(year)
    launches = self.get_launches
    net_cost = 0
    self.companies.each do |c|
      cr = c.company_reports.find_by_year(year)
      puts "Company: #{c.name}"
      puts "Fixed cost: #{cr.total_fixed_cost}"
      puts "Launches: #{launches}"
      puts "Variable cost #{c.variable_cost}"
      puts "Total #{cr.total_fixed_cost + launches * c.variable_cost}"
      net_cost += cr.total_fixed_cost + launches * c.variable_cost
      puts "Current net_cost: #{net_cost}"
    end
    net_cost
  end

  #Returns the amount of launches based on amount of sells made
  # and approximate utilization
  def get_launches
    if self.operator.product_type == 1
      max_customers = self.max_capacity * Company.get_capacity_of_launch(self.operator.product_type, self.operator.service_level)
      if max_customers == 0
        return 0
      end
      puts "Sales: #{self.sales}"
      puts "Max customers: #{max_customers}"
      perc = ((self.sales.to_f / max_customers.to_f) * 100).to_i
      if perc >= 80         #If capacity utilization is at least 80%, are launches are made
        return self.max_capacity
      elsif perc >= 60    # If utilization is between 60 and 80%, then 90% of launches are made
        return (self.max_capacity * 0.9).to_i
      elsif perc >= 40    # If utilization is between 40% and 60%, then 70% of the launches are made
        return (self.max_capacity * 0.7).to_i
      elsif perc >= 20    # If utilization is between 20% and 40%, then 50% of the launches are made
        return (self.max_capacity * 0.5).to_i
      else                      # If utilization is under 20%, return the lowest amount of launches needed to fly all customers
        if self.sales % Company.get_capacity_of_launch(self.operator.product_type, self.operator.service_level) == 0
          return self.sales / Company.get_capacity_of_launch(self.operator.product_type, self.operator.service_level)
        else
          return self.sales / Company.get_capacity_of_launch(self.operator.product_type, self.operator.service_level) + 1
        end
      end
    else

      return (self.sales.to_f / Company.get_capacity_of_launch(self.operator.product_type, self.operator.service_level)).ceil
    end
  end

  

 

  def self.get_network_satisfaction(company)
    total = 0.0
    companies = company.get_network
    market = company.get_customer_facing_company.first.role.market
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
  def self.get_weighted_satisfaction(customer_role)
    
    bonus_sat = customer_role.bonus_satisfaction
    bonus_sat = 0 if bonus_sat == nil
 
    last_sat = (customer_role.last_satisfaction != nil) ? customer_role.last_satisfaction : bonus_sat

    sat = Network.get_network_satisfaction(customer_role.company).to_f
  
    counter_weight = customer_role.market.lb_satisfaction_weight.to_f
    weight = 1 - counter_weight
    exp1 = customer_role.market.variables["exp1"].to_f
    experience = customer_role.company.network_experience.to_f / 100 * exp1
    price = customer_role.sell_price.to_f

    new_sat = (sat*weight+last_sat*counter_weight)*[0, ([experience/price, 1].min)].max**3
 
    
    customer_role.update_attribute(:last_satisfaction, new_sat)
    return new_sat
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
