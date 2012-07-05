class Network < ActiveRecord::Base
  
  has_many :companies

  def self.create_network_if_ready(contract)
    if contract.service_buyer.is_operator?
      create_network(contract.service_buyer)
    else
      create_network(contract.service_provider)
    end
  end

  def realized_value
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
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  game_id    :integer
#

