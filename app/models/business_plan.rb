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
  
  def getStatus
    if self.verified
      "Business plan has been accepted by the teacher"
    elsif self.waiting
      "Business plan is waiting for verification"
    else
      "Business plan is currently not done. Fill all the parts and then press the Submit Plan button"
    end
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

