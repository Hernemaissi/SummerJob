class Group < ActiveRecord::Base
  has_many :users
  has_one :company
  
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

