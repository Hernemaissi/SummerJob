class Rfp < ActiveRecord::Base
  attr_accessible :content, :receiver_id
  
  belongs_to :sender, class_name: "Company"
  belongs_to :receiver, class_name: "Company"
  
  has_many :bids, dependent: :destroy
  
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  def self.can_send?(sender, target)
    if sender.is_operator?
      return target.is_service? || target.is_customer_facing?
    end
    if sender.is_customer_facing? || sender.is_service?
     return  target.is_operator?
    end
    return false
  end
  
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
#  content     :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

