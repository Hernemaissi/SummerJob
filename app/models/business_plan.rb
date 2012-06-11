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
      '<span class="box verified"> Business plan status: Completed <i class="icon-ok"></i></span>'.html_safe
    elsif self.waiting
      '<span class="box waiting">Business plan status:Waiting for teacher verification</span>'.html_safe
    else
      '<span class="box unfinished" > Business plan status: Not ready </span>'.html_safe
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

