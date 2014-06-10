# == Schema Information
#
# Table name: rfps
#
#  id                  :integer          not null, primary key
#  sender_id           :integer
#  receiver_id         :integer
#  content             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  read                :boolean          default(FALSE)
#  contract_process_id :integer
#

#RFP, request for proposal, is a message sent to interesting companies.
#Bidding between companies cannot start until an RFP has been sent

class Rfp < ActiveRecord::Base
  attr_accessible :content, :receiver_id
  
  belongs_to :sender, class_name: "Company"
  belongs_to :receiver, class_name: "Company"
  
  has_many :bids, :dependent => :destroy, :order => 'id ASC'
  
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  def latest_update
  if !self.bids.empty?
    self.bids.last.updated_at
  else
    self.updated_at
  end
end


  #Returns true if sender and target need to make a contract and both are available
  def self.valid_target?(sender, target)
    if (sender.buyers.include?(target) || sender.suppliers.include?(target))
      return false
    end
    if Game.get_game.in_round(2) && (target.has_contract_with_type?(sender.service_type) || sender.has_contract_with_type?(target.service_type))
      return false
    end
    return Rfp.rfp_target?(sender, target)
  end

 #Returns true if the sender and target need to make a contract to finish round 2
  def self.rfp_target?(sender, target)
    if sender.company_type.need?(target.company_type) || target.company_type.need?(sender.company_type)
      return true
    end
    return false
  end

  #Returns true if the sender and target are valid and the sender has not yet sent an RFP to target company
  def self.can_send?(sender_user, target)
    sender_user.company && Rfp.valid_target?(sender_user.company, target) && (sender_user.company.values_decided? && target.values_decided?) && !Game.get_game.in_round(1)
  end

  #Returns true if no bid has been made or latest bid was rejected
  def can_bid?
    bids.empty? || (!bids.empty? && bids.last.rejected?)
  end

  def mark_all_bids
    self.bids.each do |b|
      b.update_attribute(:read, true)
    end
  end

end



