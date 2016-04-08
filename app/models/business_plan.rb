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
# Table name: business_plans
#
#  id             :integer          not null, primary key
#  public         :boolean          default(FALSE)
#  waiting        :boolean          default(FALSE)
#  verified       :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  company_id     :integer
#  submit_date    :datetime
#  rejected       :boolean
#  reject_message :text
#  grade          :integer
#


#Creating a business plan for the company is the main objective of round 1
#Business plan consists of multiple parts (See PlanPart)
class BusinessPlan < ActiveRecord::Base
  attr_accessible :public
  
  has_many :plan_parts, :dependent => :destroy
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
    waiting || verified || rejected
  end

  def completed?
    waiting || verified
  end

  def self.grades
    {1 => "Poor", 2 => "Bad", 3 => "Okay", 4 => "Good", 5 => "Awesome"}
  end

  def update_part_status
    self.plan_parts.each do |p|
      p.update_attribute(:updated, false)
    end
  end
  
end
