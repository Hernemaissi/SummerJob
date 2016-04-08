=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

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
    h = {"Key Partners" => "#{I18n.t :plan_help_1}"}
    h["Key Activities"] = "#{I18n.t :plan_help_2}"
    h["Value Proposition"] = "#{I18n.t :plan_help_3}"
    h["Customer Relationships"] = "#{I18n.t :plan_help_4}"
    h["Customer Segments"] = "#{I18n.t :plan_help_5}"
    h["Key Resources"] = "#{I18n.t :plan_help_6}"
    h["Channels"] = "#{I18n.t :plan_help_7}"
    h["Revenue Streams"] = "#{I18n.t :plan_help_8}"
    h["Cost Structure"] = "#{I18n.t :plan_help_9}"
    h
  end

  def get_help_text
    PlanPart.help_texts[self.title]
  end
  
end
