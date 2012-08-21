#Market is a simulation for a group of customers
#Markets have a certain amount of customers and they have preferences
#that most of the customers in the market will follow

class Market < ActiveRecord::Base
  require 'benchmark'
  attr_accessible :base_price, :customer_amount, :name, :preferred_level, :preferred_type, :price_buffer
  has_many :customer_facing_roles
  belongs_to :effect
  
  validates :base_price, presence: true

  # Returns a array of customers with all their preferences set
  # The size of the array is equal to the customer_amount of the market
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

  #Selects a company for the customer given as parameter from an array of companies
  #Each company starts with a score of 1000, and the score is decreased if the company doesn't match
  #customer preferences. Customer chooses the company with a highest remaining score
  def select_company(customer, companies)
    prng = Random.new()
    score_limit = 200
    best_score = 0
    best_company = nil
    customer_max_price = 2*customer.pref_price
    companies.shuffle!
    companies.each do |r|
      puts "Max cap is #{r.company.max_customers}"
      if r.network?
        random_buy = prng.rand(100)
        if random_buy < 5 && r.sell_price <= customer_max_price && r.company.network.sales < r.company.max_customers
          best_company = r
          best_score = 1000
          customer.random_buy = true
          break
        end
        score = 1000
        type_weight = 400
        level_weight = 300
        rep_weight = 5
        score -= (r.service_level - customer.pref_level).abs * level_weight
        score -= (r.network.operator.role.product_type - customer.pref_type).abs * type_weight
        price_difference = customer.pref_price - r.sell_price
        max_difference = 100
        if price_difference < 0
          max_difference = max_difference * (-1)
          score += [price_difference, max_difference].max
        else
          score += [price_difference, max_difference].min
        end
        if r.sell_price > customer_max_price
          score -= 3000
        end
        if r.company.network.sales >= r.company.max_customers
          score -= 3000
          puts "I can't choose that guy cause they full"
        end
        #score += (r.reputation - 100) * rep_weight
        if score > best_score
          best_score = score
          best_company = r
        end
      end
    end
    if best_company != nil && best_score >= score_limit
      customer.chosen_company = best_company
      customer.satisfaction = get_customer_satisfaction(customer, best_company, prng)
    end
  end

  #Simulates all the customers in the market and then register sales for all the companies in the market
  def complete_sales(customers_so_far, total, current_game)
    game = current_game
    total_customers = total
    current_customers = customers_so_far
    last_perc = 0
    total_satisfaction = Hash.new(0)
    game.save
    companies = self.customer_facing_roles.select { |role| role.network?  }
    @customers = self.get_customers
    @customers.each do |c|
      self.select_company(c, companies)
      if c.chosen_company != nil
        c.chosen_company.company.network.sales += 1
        total_satisfaction[c.chosen_company.id] += c.satisfaction
        puts "Network #{c.chosen_company.company.network.id} has made #{c.chosen_company.company.network.sales} sales"
      end
      current_customers += 1
      perc = ((current_customers.to_f / total_customers.to_f) *100).round
      if ( perc != 0 && perc != last_perc )
        if (perc % 10 == 0 )
          puts "#{perc}% done"
        end
        last_perc = perc
        Rails.cache.write("progress", perc)
      end
    end
    companies.each do |c|
      obtained_customers = @customers.find_all {|o|  o.chosen_company == c }
      c.register_sales(obtained_customers, total_satisfaction[c.id]) if c.network?
    end
    game.save
    @customers
  end

  def self.benchmark
    game = Game.get_game
    puts Benchmark.measure { game.end_sub_round }
  end

  #Returns customer satisfaction for a customer with customer_facing company given as parameter
  #TODO, rework to support variable cost as the meter for customer satisfaction
  def get_customer_satisfaction(customer, customer_facing, prng)
    satisfaction =  ((customer_facing.network.realized_level.to_f / customer_facing.service_level) * 100).round * 0.01
    level_weight = Random.rand(0.0...0.3)
    negative_level_weight = -1*(Random.rand(0.1...0.7))
    price_weight = Random.rand(0.0...0.3)
    negative_price_weight = -1*(Random.rand(0.1...0.7))
    type_weight = Random.rand(0.1...0.2)
    satisfaction += ((customer_facing.network.realized_level.to_f  / customer.pref_level) >= 1) ? level_weight : negative_level_weight
    expected_price = get_preferred_price(customer_facing.network.operator.role.product_type, customer_facing.network.realized_level, prng)
    expected_price +=  Random.rand(-price_buffer..price_buffer)
    satisfaction += ((expected_price/customer_facing.sell_price) >= 1) ? price_weight : negative_price_weight
    satisfaction += ((customer_facing.network.operator.role.product_type / customer.pref_type) >= 1) ? type_weight : -type_weight
    return satisfaction
  end


  #Apply an effect to the market
  #There is a 50% change of None-effect being applied to the market and
  # (0.5 * 1/n) change of specific effect being applied, where n = number of effects
  def change_market(prng)
    if prng.rand(2) == 1
      self.effect = Effect.none_effect
    else
      self.effect = Effect.all.sample
    end
    self.save!
  end

  #Applies an effect to all markets. Used after a fiscal year
  # to change the markets and force players to adapt.
  def self.apply_effects
    prng = Random.new()
    markets = Market.all
    markets.each do |m|
      m.change_market(prng)
    end
  end

  def self.do_it
    prng = Random.new()
    market = Market.find_by_name("Otaniemi")
    while market.effect_id != 3 do
      market.change_market(prng)
    end
  end

  #Calculates the market value with the current effect
  def base_price_with_effect
    val_change = (self.effect != nil) ? self.effect.value_change : 100
    return (self.base_price * (val_change.to_f / 100)).round
  end

  #Calculates the price fluctuation under current effect
  def price_buffer_with_effect
    fluc_change = (self.effect != nil) ? self.effect.fluctuation_change : 100
    return (self.price_buffer * (fluc_change.to_f / 100)).round
  end

  #Calculates the service level under current effect, level must be between 1-3
  def preferred_level_with_effect
    if self.effect != nil
      if self.effect.level_change >= 0
        return [self.preferred_level + self.effect.level_change, 3].min
      else
        return [self.preferred_level + self.effect.level_change, 1].max
      end
    else
      return self.preferred_level
    end
  end

  #Calculates the product type under current effect, level must be between 1-3
  def preferred_type_with_effect
    if self.effect != nil
      if self.effect.type_change >= 0
        return [self.preferred_type + self.effect.type_change, 3].min
      else
        return [self.preferred_type + self.effect.type_change, 1].max
      end
    else
      return self.preferred_type
    end
  end

  def test_price
    get_base_price(1,1)
  end

  private

  #Gets the preference for a single customer
  # 50% change on getting the markets preferred type, otherwise random
  def get_preferred_type(prng)
    if is_pref(prng)
      return preferred_type_with_effect
    else
      rand = Random.rand(2)
      return (rand == 0) ? 1 : 3
    end
  end

   #Gets the preference for a single customer
  # 50% change on getting the markets preferred level, otherwise random
  def get_preferred_level(prng)
    if is_pref(prng)
      return preferred_level_with_effect
    else
      rand = Random.rand(2)
      return (rand == 0) ? 1 : 3
    end
  end

  #Gets the price preference for a single customer
  def get_preferred_price(type, level, prng)
    customer_base_price = get_base_price(type, level)
    customer_base_price + prng.rand(-price_buffer_with_effect..price_buffer_with_effect)
  end

  def get_base_price(type, level)
    value_effect = (self.effect != nil) ? self.effect.value_change : 100
    if type == 1 && level == 1
      (200000 * (value_effect.to_f / 100)).round
    elsif type == 1 && level == 3
      (400000 * (value_effect.to_f / 100)).round
    elsif type == 3 && level == 1
      (20000000 * (value_effect.to_f / 100)).round
    else
      (35000000 * (value_effect.to_f / 100)).round
    end
  end

  def get_rand(limit, prng)
    prng.rand(limit)
  end

  #Returns true if customer will get market preference as it's preference
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
#  message         :string(255)
#  effect_id       :integer
#

