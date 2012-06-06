class Need < ActiveRecord::Base
  attr_accessible :needed_id
  
  belongs_to :needer, class_name: "Company"
  belongs_to :needed, class_name: "Company"
  
  validates :needer_id, presence: true
  validates :needed_id, presence: true
end
# == Schema Information
#
# Table name: needs
#
#  id         :integer         not null, primary key
#  needer_id  :integer
#  needed_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

