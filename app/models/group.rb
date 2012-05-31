class Group < ActiveRecord::Base
  has_many :users
end
# == Schema Information
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

