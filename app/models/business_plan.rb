class BusinessPlan < ActiveRecord::Base
  attr_accessible :public
  
  has_many :plan_parts
  belongs_to :company
  
  validates :company_id, presence: true
  
  def isReady?
    ready = true
    self.plan_parts.each do |part|
      ready = part.isReady?
    end
    ready
  end
  
  def done?
    waiting || verified
  end
  
end
# == Schema Information
#
# Table name: business_plans
#
#  id         :integer         not null, primary key
#  public     :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  company_id :integer
#  waiting    :boolean         default(FALSE)
#  verified   :boolean         default(FALSE)
#

