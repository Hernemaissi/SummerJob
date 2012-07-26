#Group is a model for a group of students
#Groups are the owners of companies

class Group < ActiveRecord::Base
  has_many :users
  has_one :company

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
    users.each do |u|
      unless u.position
        return false
      end
    end
    true
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
# == Schema Information
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

