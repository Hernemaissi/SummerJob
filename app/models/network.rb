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

  def get_risk_mitigation2
    risk_mit = 100
    companies.each do |c|
      risk_mit = c.risk_mitigation if c.risk_mitigation < risk_mit
    end
    self.risk_mitigation = risk_mit
    self.save!
  end

  def self.get_risk_mitigation(customer_facing_role)
    risk_mit = 100
    companies = Network.get_network(customer_facing_role)
    companies.each do |c|
      risk_mit = c.risk_mitigation if c.risk_mitigation < risk_mit
    end
    return risk_mit
  end

  def self.give_risk
    Network.all.each do |n|
      n.get_risk_mitigation
    end
  end

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

  #Returns the sell price of the customer facing company in the network
  def sell_price
    self.customer_facing.role.sell_price
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

  

  #Gets average customer satisfaction by adding the satisfaction from all companies and taking the average
  #Customer satisfaction of a single company is the relation between selected variable cost and limit
  def get_average_customer_satisfaction
    total = 0
    self.companies.each do |c|
      min_cost = Company.calculate_variable_min(c.service_level, c.product_type, c)
      actual_investment = c.variable_cost - min_cost
      actual_max = Company.calculate_variable_limit(c.service_level, c.product_type, c) - min_cost
      total += actual_investment / actual_max
    end
    sat = total / self.companies.size
    return sat
  end

  def self.get_network_satisfaction(customer_company)
    total = 0.0
    network_size = 1
    total += customer_company.get_satisfaction
    network_size += customer_company.suppliers.size
    customer_company.suppliers.each do |o|
      total += o.get_satisfaction
      network_size += o.suppliers.size
      o.suppliers.each do |s|
        total += s.get_satisfaction
      end
    end
    return total / network_size.to_f
  end

  #Returns the weighted customer satisfaction value that considers the last years customer satisfaction based on some weight
  #Params:
  #customer_role: The CustomerFacingRole of the company owning the network
  def self.get_weighted_satisfaction(customer_role)
    puts "Customer role last sat: #{customer_role.last_satisfaction}"
    puts "Bonus satisfaction at start: #{customer_role.bonus_satisfaction}"
    customer_role.bonus_satisfaction = 0 if customer_role.bonus_satisfaction == nil
    puts "Bonus satisfaction: #{customer_role.bonus_satisfaction}"
    last_sat = (customer_role.last_satisfaction != nil) ? customer_role.last_satisfaction : customer_role.bonus_satisfaction
    puts "Last sat: #{last_sat}"
    sat = Network.get_network_satisfaction(customer_role.company)
    puts "Network sat: #{sat}"
    weight = customer_role.market.get_graph_values(customer_role.service_level, customer_role.product_type)[4]
    puts "Weight is: #{weight}"
    weighted_last = last_sat * weight
    weighted_now = sat * (1-weight)
    weighted_average = weighted_last + weighted_now
    customer_role.update_attribute(:last_satisfaction, sat)
    return weighted_average
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
      n.satisfaction = nil
      n.save!
      return true
    else
      return false
    end
  end

  
  
end
