class Market < ActiveRecord::Base
  attr_accessible :base_price, :customer_amount, :name, :preferred_level, :preferred_type, :price_buffer
  has_many :customer_facing_roles
  
  validates :base_price, presence: true

  def get_customers
    prng = Random.new()
    customers = []
    for i in 1..customer_amount
      type = get_preferred_type(prng)
      level = get_preferred_level(prng)
      price = get_preferred_price(type, level, prng)
      customers << Customer.new(price, level, type)
    end
    return customers
  end

  private

  def get_preferred_type(prng)
    if is_pref(prng)
      return preferred_type
    else
      return get_rand(3, prng) + 1
    end
  end

  def get_preferred_level(prng)
    if is_pref(prng)
      return preferred_level
    else
      return get_rand(3, prng) + 1
    end
  end

  def get_preferred_price(type, level, prng)
    base_price = 1000.0
    type_weight = 0.6
    level_weight = 0.4
    customer_base_price = base_price / customer_amount
    price_before_buffer = ((type*type_weight + level*level_weight) * customer_base_price).round
    price_before_buffer + prng.rand(-price_buffer...price_buffer)
  end

  def get_rand(limit, prng)
    prng.rand(limit)
  end

  def is_pref(prng)
    if get_rand(2, prng) == 1
      true
    else
      false
    end
  end
  
end
# == Schema Information
#
# Table name: markets
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  customer_amount :integer
#  preferred_type  :integer
#  preferred_level :integer
#  base_price      :integer
#  price_buffer    :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

