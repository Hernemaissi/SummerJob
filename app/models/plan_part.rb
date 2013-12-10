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

  def self.help_texts
    h = {"Key Partners" => "Who are our Key Partners?<br/>Who are our Key suppliers?<br/>Which Key Resources are we acquiring from partners?<br/>Which Key Activities do partners perform?"}
    h["Key Activities"] = "What Key Activities do our Value Propositions require?<br/>Our Distribution Channels?<br/>Customer Relationships?<br/>Revenue streams?"
    h["Value Proposition"] = "What value do we deliver to the customer?<br/>Which one of our customer's problems are we helping to solve?<br/>What bundles of products and services are we offering to each Customer Segment?<br/>Which customer needs are we satisfying?"
    h["Customer Relationships"] = "What type of relationships does each of our Customer Segments expect us to establish and maintain with them?<br/>Which ones have we established?<br/>How are they integrated with the rest of our business model?<br/>How costly are they?"
    h["Customer Segments"] = "For whom are we creating value?<br/>Who are our most important customers?"
    h["Key Resources"] = "What key resources do our Value Propositions require?<br/>Our Distribution Channels? Customer Relationships?<br/>Revenue Streams?"
    h["Channels"] = "For whom are we creating value?<br/>Who are our most important customers?"
    h["Revenue Streams"] = "For what value are our customers really willing to pay?<br/>For what do they currently pay?<br/>How are they currently paying?<br/>How would they prefer to pay?<br/>How much does each Revenue Stream contribute to overall revenues?"
    h["Cost Structure"] = "What are the most imporant costs inherent in our business model?<br/>Which Key Resources are most expensive?<br/>Which Key Activities are most expensive?"
    h
  end

  def get_help_text
    PlanPart.help_texts[self.title]
  end
  
end
