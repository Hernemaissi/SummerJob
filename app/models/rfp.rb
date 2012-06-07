class Rfp < ActiveRecord::Base
  attr_accessible :content, :receiver_id
  
  belongs_to :sender, class_name: "Company"
  belongs_to :receiver, class_name: "Company"
  
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
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

