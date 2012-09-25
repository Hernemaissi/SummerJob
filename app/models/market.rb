

class Market < ActiveRecord::Base
  require 'benchmark'
  attr_accessible :name, :price_buffer, :lb_amount, :lb_sweet_price, :lb_max_price, :hb_amount, :hb_sweet_price, :hb_max_price, :ll_amount, :ll_sweet_price, :ll_max_price,
    :hl_amount, :hl_sweet_price, :hl_max_price, :lb_max_customers, :ll_max_customers, :hb_max_customers, :hl_max_customers, :message,
    :min_satisfaction, :expected_satisfaction, :max_satisfaction_bonus
  has_many :customer_facing_roles
  
  validates :lb_amount, presence: true, numericality: true
  validates :lb_sweet_price, presence: true, numericality: true
  validates :lb_max_price, presence: true, numericality: true
  validates :lb_max_customers, presence: true, numericality: true

  validates :hb_amount, presence: true, numericality: true
  validates :hb_sweet_price, presence: true, numericality: true
  validates :hb_max_price, presence: true, numericality: true
  validates :hb_max_customers, presence: true, numericality: true

  validates :ll_amount, presence: true, numericality: true
  validates :ll_sweet_price, presence: true, numericality: true
  validates :ll_max_price, presence: true, numericality: true
  validates :ll_max_customers, presence: true, numericality: true

  validates :hl_amount, presence: true, numericality: true
  validates :hl_sweet_price, presence: true, numericality: true
  validates :hl_max_price, presence: true, numericality: true
  validates :hl_max_customers, presence: true, numericality: true


  validates :name, presence: true

  #Returns the amount of sales the network makes
  def get_sales(network)
    graph_values = get_graph_values(network)
    sweet_spot_customers = graph_values[0]
    sweet_spot_price = graph_values[1]
    max_price = graph_values[2]
    max_customers = graph_values[3]
    if network.sell_price > sweet_spot_price
      first_x = sweet_spot_price
      first_y = sweet_spot_customers
      second_x = max_price
      second_y = 0
    else
      first_x = 0
      first_y = max_customers
      second_x = sweet_spot_price
      second_y = sweet_spot_customers
    end
    x = network.sell_price
    accessible = Market.solve_y_for_x(x, first_x, first_y, second_x, second_y)
    if accessible && !accessible.nan?
      return accessible.round
    else
      return 0
    end
  end

  #Completes the sale for every company
  def complete_sales
    self.customer_facing_roles.each do |c|
      if c.company.network
        n = c.company.network
        possible_sales = get_sales(n)
        sales_made = self.get_successful_sales(possible_sales, n)
        max_sales = n.max_capacity * Company.get_capacity_of_launch(n.operator.product_type, n.operator.service_level)
        sales_made = [sales_made, max_sales].min
        c.register_sales(sales_made)
      end
    end
  end

  #Calculates a sub-set of customers from accessible customers using random chance and customer satisfaction
  def get_successful_sales(accessible, network)
    if accessible == 0
      return 0
    end
    x = network.satisfaction
    if x == nil
      return accessible
    end
    if x <= self.expected_satisfaction
      success = Market.solve_y_for_x(x, self.min_satisfaction, 0, self.expected_satisfaction, accessible)
    else
      success = Market.solve_y_for_x(x, self.expected_satisfaction, accessible, 1, (self.max_satisfaction_bonus*accessible) )
    end
    success = success.round
    return [success, 0].max
  end

  #Returns a table with following values [SWEET_SPOT_CUSTOMERS, SWEET_SPOT_PRICE, MAX_PRICE, MAX_CUSTOMERS]
  def get_graph_values(network)
    graph_values = []
    level = network.operator.service_level
    type = network.operator.product_type
    if (level == 1 && type == 1)
      graph_values << self.lb_amount
      graph_values << self.lb_sweet_price
      graph_values << self.lb_max_price
      graph_values << self.lb_max_customers
    elsif (level == 3 && type == 1)
      graph_values << self.ll_amount
      graph_values << self.ll_sweet_price
      graph_values << self.ll_max_price
      graph_values << self.ll_max_customers
    elsif (level == 1 && type == 3)
      graph_values << self.hb_amount
      graph_values << self.hb_sweet_price
      graph_values << self.hb_max_price
      graph_values << self.hb_max_customers
    else
      graph_values << self.hl_amount
      graph_values << self.hl_sweet_price
      graph_values << self.hl_max_price
      graph_values << self.hl_max_customers
    end
    graph_values
  end


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
=begin
  def select_company(customer, companies)
    prng = Random.new()
    score_limit = 200
    best_score = 0
    best_company = nil
    customer_max_price = 2*customer.pref_price
    companies.shuffle!
    companies.each do |r|
      puts "Max cap is #{r.company.max_customers}"
      if r.network? && !r.sell_price.nil?
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
        rep_weight = 10
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
        score += (r.reputation - 100) * rep_weight
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
=end

  #Simulates all the customers in the market and then register sales for all the companies in the market
=begin
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
=end

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
  def change_market
    if Effect.all.empty?
      self.effect = Effect.none_effect
    else
      self.effect = Effect.all.sample
    end
    self.save!
  end

  #Applies an effect to all markets. Used after a fiscal year
  # to change the markets and force players to adapt.
  def self.apply_effects
    markets = Market.all
    markets.each do |m|
      m.change_market
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

  #Returns all networks who are associated with this market
  def networks
    networks = []
    self.customer_facing_roles.each do |c|
      if c.company.network
        networks << c.company.network
      end
    end
    networks
  end

  def self.solve_y_for_x(x, first_x, first_y, second_x, second_y)
    k = (second_y - first_y) / (second_x - first_x)
    return k*(x - first_x) + first_y
  end

  def total_sales
    sales = 0
    self.customer_facing_roles.each do |c|
      if c.network
        sales += c.network.sales
      end
    end
    sales
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
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  customer_amount        :integer
#  preferred_type         :integer
#  preferred_level        :integer
#  base_price             :integer
#  price_buffer           :integer
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  effect_id              :integer
#  lb_amount              :integer         default(0)
#  lb_sweet_price         :decimal(, )     default(0.0)
#  lb_max_price           :decimal(, )     default(0.0)
#  hb_amount              :integer         default(0)
#  hb_sweet_price         :decimal(, )     default(0.0)
#  hb_max_price           :decimal(, )     default(0.0)
#  ll_amount              :integer         default(0)
#  ll_sweet_price         :decimal(, )     default(0.0)
#  ll_max_price           :decimal(, )     default(0.0)
#  hl_amount              :integer         default(0)
#  hl_sweet_price         :decimal(, )     default(0.0)
#  hl_max_price           :decimal(, )     default(0.0)
#  lb_max_customers       :integer
#  ll_max_customers       :integer
#  hb_max_customers       :integer
#  hl_max_customers       :integer
#  message                :text
#  min_satisfaction       :decimal(, )     default(0.6)
#  expected_satisfaction  :decimal(, )     default(0.8)
#  max_satisfaction_bonus :decimal(, )     default(1.2)
#

