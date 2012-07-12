class Market < ActiveRecord::Base
  require 'benchmark'
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

  def select_company(customer, companies)
    prng = Random.new()
    best_score = 0
    best_company = nil
    companies.shuffle!
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
        #score += (r.reputation - 100) * rep_weight
        if score > best_score
          best_score = score
          best_company = r
        end
      end
    end
    if best_company != nil
      customer.chosen_company = best_company
      customer.satisfaction = get_customer_satisfaction(customer, best_company, prng)
    end
  end

  def complete_sales
    game = Game.get_game
    current_customers = 0
    last_perc = 0
    total_satisfaction = Hash.new(0)
    game.save
    companies = self.customer_facing_roles.select { |role| role.network?  }
    @customers = self.get_customers
    @customers.each do |c|
      self.select_company(c, companies)
      if c.chosen_company != nil
        total_satisfaction[c.chosen_company.id] += c.satisfaction
      end
      current_customers += 1
      perc = ((current_customers.to_f / self.customer_amount.to_f) *100).round
      if (perc % 10 == 0 && perc != 0 && perc != last_perc )
        puts "#{perc}% done"
        last_perc = perc
      end
    end
    companies.each do |c|
      obtained_customers = @customers.find_all {|o|  o.chosen_company == c }
      c.register_sales(obtained_customers, total_satisfaction[c.id]) if c.network?
    end
    game.save
    @customers
  end

  def benchmark
    game = Game.get_game
    puts Benchmark.measure { game.end_sub_round }
  end

  def get_customer_satisfaction(customer, customer_facing, prng)
    satisfaction =  ((customer_facing.network.realized_level.to_f / customer_facing.promised_service_level) * 100).round * 0.01
    level_weight = 0.2
    negative_level_weight = -0.6
    price_weight = 0.2
    negative_price_weight = -0.5
    type_weight = 0.2
    satisfaction += ((customer_facing.network.realized_level.to_f  / customer.pref_level) >= 1) ? level_weight : negative_level_weight
    expected_price = get_preferred_price(customer_facing.network.operator.role.product_type, customer_facing.network.realized_level, prng)
    expected_price +=  prng.rand(-price_buffer...price_buffer)
    satisfaction += ((expected_price/customer_facing.sell_price) >= 1) ? price_weight : negative_price_weight
    satisfaction += ((customer_facing.network.operator.role.product_type / customer.pref_type) >= 1) ? type_weight : -type_weight
    return satisfaction
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

