#Network is a group of companies working together
#Creating a network is main objective of round 2

class Network < ActiveRecord::Base
  has_many :companies

  belongs_to :risk

  #Calls the create_network method with different parameters depending on the contract given as parameter
  def self.create_network_if_ready(contract)
    if contract.service_buyer.is_operator?
      create_network(contract.service_buyer)
    else
      create_network(contract.service_provider)
    end
  end

  #Returns the actual realized service level of the whole network, which is the average of service company contracts and operator
  def realized_level
    sum = 0
    sum += operator.role.service_level
    operator.contracts_as_buyer.each do |c|
      sum += c.service_level
    end
    (sum.to_f / (companies.size - 1)).round
  end

  def get_risk_mitigation
    risk_mit = 100
    companies.each do |c|
      risk_mit = c.risk_mitigation if c.risk_mitigation < risk_mit && !c.is_customer_facing?
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
  #TODO, change to use the revenue from sales
  def self.calculate_score
    nets = Network.all
    nets.each do |n|
      total = 0
      n.companies.each do |c|
        total += c.profit
      end
      n.total_profit += total
      n.score += (n.total_profit * n.satisfaction).round
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

