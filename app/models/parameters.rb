# == Schema Information
#
# Table name: parameters
#
#  id              :integer          not null, primary key
#  capacity_name   :string(255)
#  experience_name :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  unit_name       :string(255)
#

class Parameters < ActiveRecord::Base
  attr_accessible :capacity_name, :experience_name, :unit_name

  acts_as_singleton
end
