class PlanPart < ActiveRecord::Base
  attr_accessible :content, :ready, :title
  
  belongs_to :business_plan
  
  validates :business_plan_id, presence: true
  
  def isReady?
    !self.title.blank? && !self.content.blank?
  end
end
# == Schema Information
#
# Table name: plan_parts
#
#  id               :integer         not null, primary key
#  title            :string(255)
#  content          :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  business_plan_id :integer
#

