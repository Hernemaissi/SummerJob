# == Schema Information
#
# Table name: effects
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  level_change       :integer
#  type_change        :integer
#  value_change       :integer
#  fluctuation_change :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# This model can be attached into the market model to modify the
# the status of a market model.

class Effect < ActiveRecord::Base
  attr_accessible :description, :fluctuation_change, :level_change, :name, :type_change, :value_change

  before_destroy :set_to_none

  validates :name, presence: true
  validates :description, :presence => true
  validates :level_change, :presence => true, :inclusion => { :in => [-2, 0, 2],
    :message => "The value must either be -2, 0 or 2" }
  validates :type_change, :presence => true, :inclusion => { :in => [-2, 0, 2],
    :message => "The value must either be -2, 0 or 2" }
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

  private

  #If an effect is destroyed, set all markets that had that effect to None
  def set_to_none
    self.markets.each do |m|
      m.effect = Effect.none_effect
      m.save!
    end
  end

end
