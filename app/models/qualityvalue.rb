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
