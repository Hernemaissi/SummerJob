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
#

class CompanyType < ActiveRecord::Base
  attr_accessible :capacity, :capacity_need, :capacity_produce, :experience, :experience_need, :experience_produce, :unit, :unit_need, :unit_produce, :name,
    :marketing_need, :marketing_produce, :limit_hash, :price_set, :image, :capital_bonus, :starting_capital

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


  
end
