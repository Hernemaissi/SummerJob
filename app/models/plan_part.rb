class PlanPart < ActiveRecord::Base
  attr_accessible :content, :ready, :title
end
# == Schema Information
#
# Table name: plan_parts
#
#  id               :integer         not null, primary key
#  title            :string(255)
#  content          :string(255)
#  ready            :boolean         default(FALSE)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  business_plan_id :integer
#

