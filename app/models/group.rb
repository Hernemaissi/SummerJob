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
# Table name: groups
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ready      :boolean          default(FALSE)
#  test       :boolean          default(FALSE)
#

#Group is a model for a group of students
#Groups are the owners of companies

class Group < ActiveRecord::Base
  has_many :users
  has_one :company

  attr_accessible :test

  #Returns what positions are still free in the group
  def free_positions
    taken_positions = []
    users.each do |u|
      if u.position
        taken_positions.push(u.position)
      end
    end
    User.positions - taken_positions
  end

  #Returns true if all users in the group have selected a position
  def all_users_have_positions
    users.reject! { |u| u.student_mode }.each do |u|
      unless u.position
        return false
      end
    end
    true
  end

  #Returns the user with position given as parameter, or nil if this position is still unassigned
  def position(pos)
    self.users.find_by_position(pos)
  end

  #Checks which of the groups given as parameter are still free (as in, are not assigned to a company) and returns
  #them as an array
  def self.free(groups)
    free_groups = []
      
    groups.each do |g|
      if !g.company
         free_groups.push(g)
      end 
    end 
    free_groups
  end
end
