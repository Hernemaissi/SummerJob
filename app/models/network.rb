class Network < ActiveRecord::Base
  has_many :companies

  def self.create_network_if_ready(contract)
    if contract.service_buyer.is_operator?
      create_network(contract.service_buyer)
    else
      create_network(contract.service_provider)
    end
  end

  def realized_level
    sum = 0
    sum += operator.role.service_level
    operator.contracts_as_buyer.each do |c|
      sum += c.service_level
    end
    (sum.to_f / (companies.size - 1)).round
  end

  def operator
    companies.each do |c|
      if c.is_operator?
        return c
      end
    end
    return nil
  end

  def customer_facing
    companies.each do |c|
      if c.is_customer_facing?
        return c
      end
    end
    return nil
  end

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

  def star_rating
    i = 0
    str = ""
    while i < rating
      str = str + "*"
      i += 1
    end
    return str
  end

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

  def self.calculate_total_profit
    nets = Network.all
    nets.each do |n|
      total = 0
      n.companies.each do |c|
        total += c.profit
      end
      n.total_profit = total
      n.save!
    end
  end

  def get_position
    nets = Network.order("total_profit DESC")
    nets.each_with_index do |n, i|
      if n == self
        return i+1
      end
    end
    return -1
  end

private

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
      customer.save!
      tech.network_id = n.id
      tech.save!
      supply.network_id = n.id
      supply.save!
      operator.network_id = n.id
      operator.save!
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
#  id           :integer         not null, primary key
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  game_id      :integer
#  sales        :integer         default(0)
#  satisfaction :decimal(, )     default(0.0)
#  total_profit :decimal(, )
#

