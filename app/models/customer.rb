class Customer
  attr_accessor :pref_price, :pref_level, :pref_type

  def initialize(pref_price, pref_level, pref_type)
    @pref_price = pref_price
    @pref_level = pref_level
    @pref_type = pref_type
  end

  def to_s
    "Type: " + @pref_type.to_s + " Level: " + @pref_level.to_s + " and price: " + @pref_price.to_s
  end
end