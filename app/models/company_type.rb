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
#  limit_hash         :text
#  price_set          :boolean
#  image              :string(255)
#  capital_bonus      :text
#  starting_capital   :integer
#  test_name          :string(255)
#

class CompanyType < ActiveRecord::Base
  attr_accessible :capacity, :capacity_need, :capacity_produce, :experience, :experience_need, :experience_produce, :unit, :unit_need, :unit_produce, :name,
    :marketing_need, :marketing_produce, :limit_hash, :price_set, :image, :capital_bonus, :starting_capital, :test_name

  serialize :limit_hash, Hash
  serialize :capital_bonus, Hash

  mount_uploader :image, ImageUploader

  has_many :companies

  def need?(other_type)
    return true if self.marketing_need && other_type.marketing_produce
    return true if self.capacity_need && other_type.capacity_produce
    return true if self.experience_need && other_type.experience_produce
    return true if self.unit_need && other_type.unit_produce
    return false
  end

  def needs
    needs = []
    needs << "marketing" if self.marketing_need
    needs << "capacity" if self.capacity_need
    needs << "unit" if self.unit_need
    needs << "experience" if self.experience_need
    needs
  end

  def produces
    produces = []
    produces << "marketing" if self.marketing_produce
    produces << "capacity" if self.capacity_produce
    produces << "unit" if self.unit_produce
    produces << "experience" if self.experience_produce
    produces
  end

  def self.anyone_needs?(parameter)
    all_needs = []
    types = CompanyType.all
    types.each do |t|
      all_needs.concat(t.needs)
    end
    return all_needs.include?(parameter)
  end

  def need_parameter?(parameter)
    if parameter == "c"
      return capacity_need
    end
    if parameter == "u"
      return unit_need
    end
    if parameter == "e"
      return experience_need
    end
    if parameter == "m"
      return marketing_need
    end
  end

  def produce_parameter?(parameter)
    if parameter == "c"
      return capacity_produce
    end
    if parameter == "u"
      return unit_produce
    end
    if parameter == "e"
      return experience_produce
    end
    if parameter == "m"
      return marketing_produce
    end
  end


  
end
