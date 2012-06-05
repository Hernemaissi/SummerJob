class Company < ActiveRecord::Base
  
  after_create :init_business_plan
  
  attr_accessible :name, :group_id, :service_type, :size, :about_us
  belongs_to :group
  has_one :business_plan
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :group_id, presence: true
  validates :fixedCost, presence: true
  validates :variableCost, presence: true
  validates :revenue, presence: true
  validates :profit, presence: true
  
  def self.types
    ['Customer', 'Marketing', 'Technology', 'Supplier']
  end
  
  private
  def init_business_plan
    plan = self.create_business_plan
    size = self.group.users.count
    i = 0;
    while i < size do
      plan.plan_parts.create
      i+= 1
    end
  end
    
  
end
# == Schema Information
#
# Table name: companies
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  fixedCost       :decimal(5, 2)   default(0.0)
#  variableCost    :decimal(5, 2)   default(0.0)
#  revenue         :decimal(5, 2)   default(0.0)
#  profit          :decimal(5, 2)   default(0.0)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  group_id        :integer
#  max_capacity    :integer
#  capacity        :integer         default(0)
#  max_quality     :integer
#  quality         :integer         default(0)
#  penetration     :integer         default(0)
#  max_penetration :integer
#  service_type    :string(255)
#  initialised     :boolean         default(FALSE)
#  about_us        :string(255)
#  size            :integer
#

