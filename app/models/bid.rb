class Bid < ActiveRecord::Base
  attr_accessible :amount, :message, :offer
  
  belongs_to :rfp
  
  validates :amount, presence: true
  validates :offer, presence: true
  validates :message, presence: true
  validates :status, presence: true
  validates :rfp_id, presence: true
  
  def accepted
    return "ACC"
  end
  
  def waiting
    return "WAI"
  end
  
  def rejected
    return "REJ"
  end
  
  def accepted?
    self.status == self.accepted
  end
  
  def waiting?
    self.status == self.waiting
  end
  
  def rejected?
    self.status == self.rejected
  end
  
end
# == Schema Information
#
# Table name: bids
#
#  id         :integer         not null, primary key
#  offer      :integer
#  amount     :integer
#  message    :string(255)
#  status     :string(255)
#  rfp_id     :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

