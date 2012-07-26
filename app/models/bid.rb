
#Bids are responses to an RFP.
class Bid < ActiveRecord::Base
  attr_accessible :amount, :message, :offer, :service_level
  
  belongs_to :rfp
  has_one :contract, :dependent => :destroy

  validate :validate_specialize
  validates :service_level, :numericality => { :greater_than => 0, :less_than_or_equal_to => 3 }
  
  
  validates :amount, presence: true
  validates :offer, presence: true
  validates :message, presence: true
  validates :status, presence: true
  validates :service_level, presence: true
  validates :rfp_id, presence: true

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

  #Returns the receiver of the bid
  def receiver
    if counter
      self.rfp.receiver
    else
      self.rfp.sender
    end
  end

  #Returns the sender of the bid
  def sender
    if counter
      self.rfp.sender
    else
      self.rfp.receiver
    end
  end

  #Returns the company that will provide the service in this particular case
  def provider
    if self.receiver.is_service?
      return self.receiver
    elsif self.sender.is_service?
      return self.sender
    elsif self.receiver.is_operator?
      return self.receiver
    else
      return self.sender
    end
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
    self.offer = "#{self.amount} for service with service level #{self.service_level}"
  end

  #Creates a new contract between two companies based on an accepted bid
  def sign_contract!
    contract = self.create_contract
    contract.service_provider_id = self.provider.id
    contract.service_buyer_id = self.buyer.id
    contract.save!
    Network.create_network_if_ready(contract)
    contract
  end

  #Checks if the receiving party is able to accept a bid
  def can_accept?
   (( !self.provider.role.specialized? || self.provider.role.service_level == self.service_level) || self.agreement? ) && can_bid?
  end

  #Checks if a new bid can be sent
  def can_bid?
    Rfp.valid_target?(rfp.sender, rfp.receiver)
  end

  #Checks if a bid has not yet been read by a company given as a parameter
  def unread?(company)
       (!self.read && self.receiver == company && self.waiting?) || (!self.read && self.sender == company && !self.waiting?)
  end

  #Checks that a service provider cannot provide service outside their specialization if they are specialized.
  def validate_specialize
    if self.provider.role.specialized? && self.service_level != self.provider.role.service_level && self.sender == self.provider && !self.agreement?
      errors.add(:service_level, "has to match the service providers service level if they are specialized")
    end
  end
  
end
# == Schema Information
#
# Table name: bids
#
#  id            :integer         not null, primary key
#  amount        :integer
#  message       :string(255)
#  status        :string(255)
#  rfp_id        :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  offer         :string(255)
#  counter       :boolean
#  service_level :integer
#  read          :boolean         default(FALSE)
#

