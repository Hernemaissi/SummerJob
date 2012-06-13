class Network < ActiveRecord::Base
  
  has_many :companies
  
end
# == Schema Information
#
# Table name: networks
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  game_id    :integer
#

