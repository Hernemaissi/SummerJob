# == Schema Information
#
# Table name: contracts
#
#  id                    :integer          not null, primary key
#  service_provider_id   :integer
#  service_buyer_id      :integer
#  bid_id                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  new_amount            :integer
#  under_negotiation     :boolean          default(FALSE)
#  negotiation_sender_id :integer
#  negotiation_type      :string(255)
#  actual_launches       :integer
#  launches_made         :integer          default(0)
#


#Contracts are formed between companies after a bid is accepted
class Contract < ActiveRecord::Base
  attr_accessible :new_amount,  :under_negotiation
  
  belongs_to :bid
  belongs_to :service_provider, class_name: "Company"
  belongs_to :service_buyer, class_name: "Company"
  belongs_to :negotiation_sender, class_name: "Company"
  
  validates :service_provider_id, presence: true
  validates :service_buyer_id, presence: true
  validates :bid_id, presence: true
  validates :new_amount, :numericality => { :greater_than => 0 }, :on => :update

  #Shortcut to check the amount of the accepted bid
  def amount
    bid.amount
  end

  #Returns the party that must respond to a re-negotiation request
  def negotiation_receiver
    if negotiation_sender == service_provider
      service_buyer
    else
      service_provider
    end
  end

  def self.update_contracts
    contracts = Contract.all
    contracts.each do |c|
      if c.bid.remaining_duration
        c.bid.update_attribute(:remaining_duration, c.bid.remaining_duration - 1)
        if c.bid.remaining_duration <= 0
          c.bid.update_attribute(:status, Bid.rejected)
          c.destroy
        end
      end
    end
  end

  def self.renegotiation
    "REN"
  end

  def self.end_contract
    "END"
  end

  def self.valid_actual_launches(company, launches)
    launches = launches.to_i
    return (launches >= 0 && launches <= company.max_capacity)
  end

  def self.update_actual_launches(company, contract_ids, launches_array)
    launches_array = launches_array.collect{|i| i.to_i}
    total_launches = launches_array.sum
    puts "#{total_launches} / #{company.max_capacity}"
    negative_values = false
    launches_array.each do |n|
      negative_values = true if n.to_i < 0
    end
    if Contract.valid_actual_launches(company, total_launches) && !negative_values
      contract_ids.each_with_index do |id, i|
        contract = Contract.find(id)
        contract.update_attribute(:actual_launches, launches_array[i])
      end
      return true
    end
    return false
  end

  #debug
  def self.fix_contracts
    Contract.all.each do |c|
      if !c.actual_launches
        c.update_attribute(:actual_launches, c.service_provider.max_capacity)
      end
    end
  end

end
