class Customer
  attr_accessor :pref_price, :pref_level, :pref_type, :chosen_company, :satisfaction, :expected_price, :random_buy

  def initialize(pref_price, pref_level, pref_type)
    @pref_price = pref_price
    @pref_level = pref_level
    @pref_type = pref_type
    @random_buy = false
  end

  def rating
    case @satisfaction
    when 0...0.4
      return 1
    when 0.4...0.65
      return 2
    when 0.65...0.85
      return 3
    when 0.85...0.99
      return 4
    else
      return 5
    end
  end

  def satisfaction_to_s
    str = "Satisfaction is: " + @satisfaction.to_s + " Star rating is: "
    i = 0
    while i < rating
      str = str + "*"
      i += 1
    end
    str
  end

  def to_s
    "Type: " + @pref_type.to_s + " Level: " + @pref_level.to_s + " and price: " + @pref_price.to_s + ". Chose company: " + @chosen_company.company.name
  end
end