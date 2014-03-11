# == Schema Information
#
# Table name: company_types
#
#  id                 :integer          not null, primary key
#  capacity_need      :boolean
#  capacity_produce   :boolean
#  experience_need    :boolean
#  experience_produce :boolean
#  unit_need          :boolean
#  unit_produce       :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  name               :string(255)
#  marketing_need     :boolean
#  marketing_produce  :boolean
#

class CompanyType < ActiveRecord::Base
  attr_accessible :capacity, :capacity_need, :capacity_produce, :experience, :experience_need, :experience_produce, :unit, :unit_need, :unit_produce, :name,
    :marketing_need, :marketing_produce

  has_many :companies


  
end
