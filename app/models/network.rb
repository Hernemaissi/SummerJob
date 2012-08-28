#Network is a group of companies working together
#Creating a network is main objective of round 2

class Network < ActiveRecord::Base
  has_many :companies
  has_many :network_reports

  belongs_to :risk

  #Calls the create_network method with different parameters depending on the contract given as parameter
  def self.create_network_if_ready(contract)
    if contract.service_buyer.is_operator?
      create_network(contract.service_buyer)
    else
      create_network(contract.service_provider)
    end
  end

  #Not used anymore, exists only for some compatibility things, TODO delete
  def realized_level
    operator.service_level
  end

  def get_risk_mitigation
    risk_mit = 100
    companies.each do |c|
      risk_mit = c.risk_mitigation if c.risk_mitigation < risk_mit
      puts "Current company #{c.name} with risk #{c.risk_mitigation}"
    end
    self.risk_mitigation = risk_mit
    self.save!
  end

  def self.give_risk
    Network.all.each do |n|
      n.get_risk_mitigation
    end
  end

  #Returns the operator company of the network
  def operator
    companies.each do |c|
      if c.is_operator?
        return c
      end
    end
    return nil
  end

  #Returns the customer facing company of the network
  def customer_facing
    companies.each do |c|
      if c.is_customer_facing?
        return c
      end
    end
    return nil
  end

  #Returns the tech company of the network
  def tech
    companies.each do |c|
      if c.is_tech?
        return c
      end
    end
    return nil
  end

  #Returns the supply company of the network
  def supply
    companies.each do |c|
      if c.is_supply?
        return c
      end
    end
    return nil
  end
  
  #Returns the amount of stars the company earned based on customer satisfaction
  def rating
    case satisfaction
    when 0...0.4
      return 1
    when 0.4...0.65
      return 2
    when 0.65...0.85
      return 3
    when 0.85...0.99
      return 4
    else
      return 5
    end
  end

  #Returns a string of '*' to show the received stars, Used for debug
  def star_rating
    i = 0
    str = ""
    while i < rating
      str = str + "*"
      i += 1
    end
    return str
  end

  #Returns the appropriate reputation change for the network based on the rating
  def reputation_change
    case rating
    when 1
      -10
    when 2
      -5
    when 3
      0
    when 4
      5
    when 5
      10
    end
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
    report.promised_level = self.customer_facing.role.service_level
    report.realized_level = self.realized_level
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

  #Returns the amount of launches based on amount of sells made
  # and approximate utilization
  def get_launches
    if self.operator.product_type == 1
      max_customers = self.max_capacity * Company.get_capacity_of_launch(self.operator.product_type)
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
        if self.sales % Company.get_capacity_of_launch(self.operator.product_type) == 0
          return self.sales / Company.get_capacity_of_launch(self.operator.product_type)
        else
          return self.sales / Company.get_capacity_of_launch(self.operator.product_type) + 1
        end
      end
    else
      return self.sales / Company.get_capacity_of_launch(self.operator.product_type)
    end
  end

  

  #Gets average customer satisfaction by adding the satisfaction from all companies and taking the average
  #Customer satisfaction of a single company is the relation between selected variable cost and limit
  def get_average_customer_satisfaction
    total = 0
    self.companies.each do |c|
      total += c.variable_cost / Company.calculate_variable_limit(c.service_level, c.product_type)
    end
    sat = total / self.companies.size
    return sat + 0.4
  end

private

  #Creates a new network if all necessary contracts are made
  def self.create_network(operator)
    customer = nil
    tech = nil
    supply = nil
    operator.contracts_as_supplier.each do |c|
      if c.service_buyer.is_customer_facing?
        customer = c.service_buyer
      end
    end
    operator.contracts_as_buyer.each do |c|
      if c.service_provider.is_tech?
        tech = c.service_provider
      end
      if c.service_provider.is_supply?
        supply = c.service_provider
      end
    end
    if customer && tech && supply
      n = Network.create!
      customer.network_id = n.id
      customer.belongs_to_network = true
      customer.role.belongs_to_network = true
      customer.save!
      customer.role.save!
      tech.network_id = n.id
      tech.save!
      supply.network_id = n.id
      supply.save!
      operator.network_id = n.id
      operator.save!
      n.get_risk_mitigation
      return true
    else
      return false
    end
  end

  
  
end
# == Schema Information
#
# Table name: networks
#
#  id              :integer         not null, primary key
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  game_id         :integer
#  sales           :integer         default(0)
#  satisfaction    :decimal(, )     default(0.0)
#  total_profit    :decimal(20, 2)  default(0.0)
#  score           :integer         default(0)
#  risk_mitigation :integer         default(0)
#  risk_id         :integer
#

