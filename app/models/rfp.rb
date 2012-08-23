#RFP, request for proposal, is a message sent to interesting companies.
#Bidding between companies cannot start until an RFP has been sent

class Rfp < ActiveRecord::Base
  attr_accessible :content, :receiver_id
  
  belongs_to :sender, class_name: "Company"
  belongs_to :receiver, class_name: "Company"
  
  has_many :bids, :dependent => :destroy
  
  validates :sender_id, presence: true
  validates :receiver_id, presence: true


  #Returns true if the sender and target need to make a contract to finish round 2
  def self.valid_target?(sender, target)
    if target.has_contract_with_type?(sender.service_type) || sender.has_contract_with_type?(target.service_type)
      return false
    end
    if sender.is_operator?
      return target.is_service? || target.is_customer_facing?
    end
    if sender.is_customer_facing? || sender.is_service?
     return  target.is_operator?
    end
  end

  #Returns true if the sender and target are valid and the sender has not yet sent an RFP to target company
  def self.can_send?(sender_user, target)
    sender_user.company && Rfp.valid_target?(sender_user.company, target) &&  !sender_user.company.has_sent_rfp?(target) && (sender_user.company.values_decided? && target.values_decided?)
  end

  #Returns true if no bid has been made or latest bid was rejected
  def can_bid?
    bids.empty? || (!bids.empty? && bids.last.rejected?)
  end
end
# == Schema Information
#
# Table name: rfps
#
#  id          :integer         not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  content     :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  read        :boolean         default(FALSE)
#

