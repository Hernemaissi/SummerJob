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
# Table name: qualityvalues
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  quality_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Qualityvalue < ActiveRecord::Base
  attr_accessible :quality_id, :value
  has_and_belongs_to_many :users
  belongs_to :quality
end
