# This model can be attached into the market model to modify the
# the status of a market model.

class Effect < ActiveRecord::Base
  attr_accessible :description, :fluctuation_change, :level_change, :name, :type_change, :value_change

  validates :name, presence: true
  validates :description, :presence => true
  validates :level_change, :presence => true, :numericality => { :greater_than => -3, :less_than_or_equal_to => 2 }
  validates :type_change, :presence => true, :numericality => { :greater_than => -3, :less_than_or_equal_to => 2 }
  validates :value_change, :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 200 }
  validates :fluctuation_change, :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 200 }

  has_many :markets

  #Returns the "None" -effect (meaning no effect is applied)
  #If none effect is not found in the database, one is created
  def self.none_effect
    effect = Effect.find_by_name("None")
    if !effect
      effect = Effect.new(:name => "None", :description => "Market is normal", :level_change => 0, :type_change => 0, :value_change => 100, :fluctuation_change => 100)
      effect.save!
    end
    return effect
  end

end

# == Schema Information
#
# Table name: effects
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  description        :string(255)
#  level_change       :integer
#  type_change        :integer
#  value_change       :integer
#  fluctuation_change :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

