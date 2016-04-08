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
# Table name: revisions
#
#  id                     :integer          not null, primary key
#  company_id             :integer
#  value_proposition      :text
#  revenue_streams        :text
#  cost_structure         :text
#  key_resources          :text
#  key_activities         :text
#  customer_segments      :text
#  key_partners           :text
#  channels               :text
#  customer_relationships :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  reasoning              :text
#  grade                  :integer
#  feedback               :text
#  read                   :boolean          default(TRUE)
#

class Revision < ActiveRecord::Base
  attr_accessible :channels, :company_id, :cost_structure, :customer_relationships, :customer_segments, :key_activities, :key_partners, :key_resources, :revenue_streams, :value_proposition, :grade, :feedback

  belongs_to :company

  def self.grades
    [0, 1, 2, 3, 4, 5]
  end

end
