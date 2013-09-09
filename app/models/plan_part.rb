# == Schema Information
#
# Table name: plan_parts
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  business_plan_id :integer
#  position         :string(255)
#  outer            :boolean          default(FALSE)
#  updated          :boolean          default(TRUE)
#


#Plan parts always belong to a certain business plan.
#When all parts are finished, the whole plan is considered ready. Single part is ready once it has a title and content
#Plan parts also have position who is responsible in filling that particular part.
class PlanPart < ActiveRecord::Base
  attr_accessible :content, :ready
  
  belongs_to :business_plan
  
  validates :business_plan_id, presence: true

  #Checks if a single part is finished
  def isReady?
    self.title == "Reasoning" || (!self.title.blank? && !self.content.blank?)
  end

  #Returns status code for a business plan part that can be edited by anybody
  def self.free
    "FREE"
  end

  #Returns true if anybody is allowed to edit a particular part
  def anybody?
    self.position == PlanPart.free || !self.business_plan.company.group.users.find_by_position(self.position)
  end
  
end
