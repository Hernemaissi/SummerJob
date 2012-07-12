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
    customer.chosen_company = best_company
    customer.satisfaction = get_customer_satisfaction(best_company)
  end

  def complete_sales
    game = Game.get_game
    game.calculating = true
    current_customers = 0
    last_perc = 0
    total_satisfaction = Hash.new(0)
    game.save
    companies = self.customer_facing_roles
    @customers = self.get_customers
    @customers.each do |c|
      self.select_company(c, companies)
      total_satisfaction[c.chosen_company.id] += c.satisfaction
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
    game.calculating = false
    game.save
    @customers
  end

  def benchmark
    puts Benchmark.measure { self.complete_sales }
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

