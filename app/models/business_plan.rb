
#Creating a business plan for the company is the main objective of round 1
#Business plan consists of multiple parts (See PlanPart)
class BusinessPlan < ActiveRecord::Base
  attr_accessible :public
  
  has_many :plan_parts
  belongs_to :company
  
  validates :company_id, presence: true

  #Checks if the business plan is ready to be submitted
  def isReady?
    self.plan_parts.each do |part|
      if !part.isReady?
        return false
      end
    end
    return true
  end

  #Checks if business plan is finished student side
  def done?
    waiting || verified
  end
  
end
# == Schema Information
#
# Table name: business_plans
#
#  id          :integer         not null, primary key
#  public      :boolean         default(FALSE)
#  waiting     :boolean         default(FALSE)
#  verified    :boolean         default(FALSE)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  company_id  :integer
#  submit_date :datetime
#

