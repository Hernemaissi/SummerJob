class Company < ActiveRecord::Base
  attr_accessible :name, :group_id
  belongs_to :group
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :group_id, presence: true
  validates :fixedCost, presence: true
  validates :variableCost, presence: true
  validates :revenue, presence: true
  validates :profit, presence: true
  
end
# == Schema Information
#
# Table name: companies
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  fixedCost    :decimal(5, 2)   default(0.0)
#  variableCost :decimal(5, 2)   default(0.0)
#  revenue      :decimal(5, 2)   default(0.0)
#  profit       :decimal(5, 2)   default(0.0)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  group_id     :integer
#

