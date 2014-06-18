# == Schema Information
#
# Table name: bids
#
#  id                  :integer          not null, primary key
#  amount              :integer
#  message             :text
#  status              :string(255)
#  rfp_id              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  offer               :string(255)
#  counter             :boolean
#  read                :boolean          default(FALSE)
#  reject_message      :text
#  agreed_duration     :integer
#  remaining_duration  :integer
#  penalty             :decimal(20, 2)   default(0.0)
#  launches            :integer
#  broken              :boolean          default(FALSE)
#  marketing_amount    :integer
#  experience_amount   :integer
#  unit_amount         :integer
#  capacity_amount     :integer
#  contract_process_id :integer
#  receiver_id         :integer
#  sender_id           :integer
#


#Bids are responses to an RFP.
class Bid < ActiveRecord::Base
  attr_accessible :amount, :message, :offer, :agreed_duration, :penalty, :launches, :marketing_amount, :experience_amount, :unit_amount, :capacity_amount
  
  belongs_to :contract_process
  has_one :contract, :dependent => :destroy
  belongs_to :sender, class_name: "Company"
  belongs_to :receiver, class_name: "Company"
  
  
  validates :amount, numericality: true
  validates :message, presence: true
  validates :status, presence: true
  validates :agreed_duration, :numericality => true, :allow_nil => true
  validates :penalty, :numericality => true

  parsed_fields :amount, :penalty

  #Returns a status code for accepted bid
  def self.accepted
    return "ACC"
  end

  #Returns a status code for standing bid
  def self.waiting
    return "WAI"
  end

  #Returns status code for rejected bid
  def self.rejected
    return "REJ"
  end

  #Checks if bid has been accepted
  def accepted?
    self.status == Bid.accepted
  end

  #Check if bid has been rejected
  def rejected?
    self.status == Bid.rejected
  end

  #Checks if bid is still waiting for a response
  def waiting?
    !self.accepted? && !self.rejected?
  end
  
  def decided?
    !self.waiting?
  end

 

  #Returns the company that will provide the service in this particular case
  def provider
    return (self.receiver.company_type.marketing_produce?) ? self.receiver : self.sender if self.marketing_present?
    return (self.receiver.company_type.capacity_produce?) ? self.receiver : self.sender if self.capacity_present?
    return (self.receiver.company_type.experience_produce?) ? self.receiver : self.sender if self.experience_present?
    return (self.receiver.company_type.unit_produce?) ? self.receiver : self.sender if self.unit_present?
  end

  #Returns the company that will buy the service in this particular case
  def buyer
    if self.receiver == self.provider
      return self.sender
    else
      return self.receiver
    end
  end

  #Returns true if the bid is between a operator company and a customer facing company
  def agreement?
    self.provider.is_operator?
  end
  
  def status_to_s
    if accepted?
      "Accepted"
    elsif rejected?
      "Rejected"
    else
      "Waiting"
    end
  end

  #Creates a description of the offer based on offer amount and service level
  def create_offer
    self.offer = "#{self.amount} per launch"
  end

  #Creates a new contract between two companies based on an accepted bid
  def sign_contract!
    contract = self.create_contract
    contract.service_provider_id = self.provider.id
    contract.service_buyer_id = self.buyer.id
    contract.save!
    #Network.create_network_if_ready(contract)
    contract
  end

  #Checks if the receiving party is able to accept a bid
  def can_accept?
   can_bid?
  end

  #Checks if a new bid can be sent
  def can_bid?
    Bid.offer_target?(sender, receiver) && !sender.has_contract_with?(receiver)
  end

  def self.offer_target?(sender, target)
    target.company_type.need?(sender.company_type)
  end

  def self.can_offer?(sender_user, target)
    sender_user.company && Bid.offer_target?(sender_user.company, target) && (sender_user.company.values_decided? && target.values_decided?) && !Game.get_game.in_round(1) &&
      Bid.need_offer?(sender_user.company, target)
  end

  def self.need_offer?(seller, buyer)
    process = ContractProcess.find_by_parties(seller, buyer)
    if process && !process.bids.empty?
      return !(process.bids.last.waiting? || process.bids.last.accepted?)
    end
    return true
  end

  #Checks if a bid has not yet been read by a company given as a parameter
  def unread?(company)
       (!self.read && self.receiver == company && self.waiting?) || (!self.read && self.sender == company && !self.waiting?)
  end

  def marketing_present?
    return (sender.company_type.marketing_need? && receiver.company_type.marketing_produce?) || (sender.company_type.marketing_produce? && receiver.company_type.marketing_need?)
  end

  def experience_present?
    return (sender.company_type.experience_need? && receiver.company_type.experience_produce?) || (sender.company_type.experience_produce? && receiver.company_type.experience_need?)
  end

  def unit_present?
    return (sender.company_type.unit_need? && receiver.company_type.unit_produce?) || (sender.company_type.unit_produce? && receiver.company_type.unit_need?)
  end

  def capacity_present?
    return (sender.company_type.capacity_need? && receiver.company_type.capacity_produce?) || (sender.company_type.capacity_produce? && receiver.company_type.capacity_need?)
  end




  
end
