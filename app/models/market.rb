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

  def get_scores(customer)
    #TODO: ADD REPUTATION
    score_hash = {}
    companies = self.customer_facing_roles.shuffle
    companies.each do |r|
      if r.network?
        score = 1000
        type_weight = 200
        level_weight = 100
        rep_weight = 5
        score -= (r.promised_service_level - customer.pref_level).abs * level_weight
        score -= (r.network.operator.role.product_type - customer.pref_type).abs * type_weight
        price_difference = customer.pref_price - r.sell_price
        max_difference = 100
        if price_difference < 0
          max_difference = max_difference * (-1)
          score += [price_difference, max_difference].max
        else
          score += [price_difference, max_difference].min
        end
        score += (r.reputation - 100) * rep_weight
        score_hash[r.company.name] = score
      end
    end
    score_hash = score_hash.sort_by { |name, score| -score }
    customer.chosen_company = Company.find_by_name(score_hash.first[0])
    customer.satisfaction = get_customer_satisfaction(customer.chosen_company.role)
    return score_hash
  end

  def get_score_array(customers)
    score_array = []
    customers.each do |c|
      score_array << get_scores(c)
    end
    return score_array
  end

  def get_customer_satisfaction(customer_facing)
    return ((customer_facing.network.realized_level.to_f / customer_facing.promised_service_level) * 100).round * 0.01
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

