# == Schema Information
#
# Table name: markets
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  customer_amount        :integer
#  preferred_type         :integer
#  preferred_level        :integer
#  base_price             :integer
#  price_buffer           :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  effect_id              :integer
#  lb_amount              :integer          default(0)
#  lb_sweet_price         :integer          default(0)
#  lb_max_price           :integer          default(0)
#  hb_amount              :integer          default(0)
#  hb_sweet_price         :integer          default(0)
#  hb_max_price           :integer          default(0)
#  ll_amount              :integer          default(0)
#  ll_sweet_price         :integer          default(0)
#  ll_max_price           :integer          default(0)
#  hl_amount              :integer          default(0)
#  hl_sweet_price         :integer          default(0)
#  hl_max_price           :integer          default(0)
#  lb_max_customers       :integer
#  ll_max_customers       :integer
#  hb_max_customers       :integer
#  hl_max_customers       :integer
#  message                :text
#  min_satisfaction       :decimal(, )      default(0.6)
#  expected_satisfaction  :decimal(, )      default(0.8)
#  max_satisfaction_bonus :decimal(, )      default(1.2)
#  risk_id                :integer
#  lb_satisfaction_weight :decimal(2, 1)    default(0.0)
#  ll_satisfaction_weight :decimal(2, 1)    default(0.0)
#  hb_satisfaction_weight :decimal(2, 1)    default(0.0)
#  hl_satisfaction_weight :decimal(2, 1)    default(0.0)
#  satisfaction_limits    :text
#



class Market < ActiveRecord::Base
  require 'benchmark'
  attr_accessible :name, :price_buffer, :lb_amount, :lb_sweet_price, :lb_max_price, :hb_amount, :hb_sweet_price, :hb_max_price, :ll_amount, :ll_sweet_price, :ll_max_price,
    :hl_amount, :hl_sweet_price, :hl_max_price, :lb_max_customers, :ll_max_customers, :hb_max_customers, :hl_max_customers, :message,
    :min_satisfaction, :expected_satisfaction, :max_satisfaction_bonus, :lb_satisfaction_weight, :ll_satisfaction_weight, :hb_satisfaction_weight, :hl_satisfaction_weight
  serialize :satisfaction_limits, Hash
  has_many :customer_facing_roles
  belongs_to :risk
  
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

  parsed_fields :lb_sweet_price, :lb_max_price, :hb_sweet_price, :hb_max_price,
                :ll_sweet_price, :ll_max_price, :hl_sweet_price, :hl_max_price


  validates :name, presence: true

  #Returns the amount of sales the network makes
  def get_sales(customer_role)
    graph_values = get_graph_values(customer_role.service_level, customer_role.product_type)
    sweet_spot_customers = graph_values[0]
    sweet_spot_price = graph_values[1]
    max_price = graph_values[2]
    max_customers = graph_values[3]
    if customer_role.sell_price > sweet_spot_price
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
    x = customer_role.sell_price
    Rails.logger.debug("debug::" + "Sell price in get_sales: #{x}")
    Rails.logger.debug("debug::" + "Sweet price: #{sweet_spot_price}")
    accessible = Market.solve_y_for_x(x, first_x, first_y, second_x, second_y)
    accessible = accessible.to_f
    Rails.logger.debug("debug::" + "Accessible in sales: #{accessible}")
    if accessible && !accessible.nan? && !accessible.infinite?
      accessible = [accessible, 0].max
      return accessible.round
    else
      return 0
    end
  end

  #TODO: Fix situation where really low accessible can still result in big sales if share is big
  #Completes the sale for every company
  def complete_sales
    shares = self.market_share
    self.customer_facing_roles.each do |c|
      if c.company.part_of_network
        type = c.service_level.to_s + c.product_type.to_s + "t"
        bonus_type = c.service_level.to_s + c.product_type.to_s + "b"
        if shares[c.id] && shares[c.id] != 0
          company_share_per = shares[c.id].to_f / shares[type].to_f
          sales_made = company_share_per * (get_graph_values(c.service_level, c.product_type)[3]  + shares[bonus_type])
          #Temp fix
          sales_made = shares[c.id] if shares[c.id] < sales_made
        else
          sales_made = 0
        end
        
        max_sales = c.company.network_launches * Company.get_capacity_of_launch(c.product_type, c.service_level)
        sales_made = [sales_made, max_sales].min
        c.register_sales(sales_made.to_i)
      end
    end
  end

  #DEBUG
  def debug_share(c)
    shares = self.market_share
    type = c.service_level.to_s + c.product_type.to_s + "t"
    if shares[c.id] && shares[c.id] != 0
      company_share_per = shares[c.id].to_f / shares[type].to_f
      sales_made = company_share_per * get_graph_values(c.service_level, c.product_type)[3]
      sales_made = shares[c.id] if shares[c.id] < sales_made
    else
      sales_made = 0
    end
    puts "Company share per: #{company_share_per}"
    puts "Shares for c.id: #{shares[c.id]}"
    puts "Shares for type: #{shares[type]}"
    return sales_made.to_i
  end

  #Calculates a sub-set of customers from accessible customers based on customer satisfaction
  def get_successful_sales(accessible, customer_role)
    x = Network.get_weighted_satisfaction(customer_role)
    limits = self.get_satisfaction_limits(customer_role.product_type, customer_role.service_level)
    min_sat = limits[0]
    expected_sat = limits[1]
    bonus_sat = limits[2]
    if accessible == 0
      return 0
    end 
    puts "Value of x: #{x}"
    if x == nil
      return accessible
    end
    if x <= expected_sat
      success = Market.solve_y_for_x(x, min_sat, 0, expected_sat, accessible)
    else
      success = Market.solve_y_for_x(x, expected_sat, accessible, 1, (bonus_sat*accessible) )
    end
    success = success.round
    return [success, 0].max
  end

  #Calculates the market share
  #Param: If set to true, ignores the part_of_network check, used when simulating results
  def market_share(simulated = false)
    shares = {}
    shares["11t"] = 0
    shares["13t"] = 0
    shares["31t"] = 0
    shares["33t"] = 0
    shares["11b"] = 0
    shares["13b"] = 0
    shares["31b"] = 0
    shares["33b"] = 0
    self.customer_facing_roles.each do |c|
      if c.company.part_of_network || simulated
        c.reload if simulated


        accessible = self.get_sales(c)
        sales = self.get_successful_sales(accessible, c)
        bonus = sales - accessible
        type = c.service_level.to_s + c.product_type.to_s + "t"
        shares[c.id] = sales
        shares[type] += sales
        if (bonus > 0)
          bonus_type = c.service_level.to_s + c.product_type.to_s + "b"
          shares[bonus_type] += bonus
        end
      end
    end
    return shares
  end

  #Simulate sales for the test table
  def simulate_sales(c, launches)
    accessible = self.get_sales(c)
    Rails.logger.debug("debug::" + "Accessible #{accessible}")
    puts "Accesible: #{accessible}"
    sales = self.get_successful_sales(accessible, c)
    puts "Sales: #{sales}"
    Rails.logger.debug("debug::" + "Sales #{sales}")
    Rails.logger.debug("debug::" + "Price #{c.sell_price}")
    if sales && sales != 0
      company_share_per = 1
      sales_made = company_share_per * get_graph_values(c.service_level, c.product_type)[3]
      sales_made = sales if sales < sales_made
      max_sales = launches * Company.get_capacity_of_launch(c.product_type, c.service_level)
      sales_made = [sales_made, max_sales].min
    else
      sales_made = 0
    end

    return sales_made.to_i
  end

  #Method used for drawing the test graphs for markets
  def self.get_test_profit(price, max_capacity, level, type, market)
    graph_values = market.get_graph_values(level, type)
    sweet_spot_customers = graph_values[0]
    sweet_spot_price = graph_values[1]
    max_price = graph_values[2]
    max_customers = graph_values[3]
    if price > sweet_spot_price
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
    x = price
    accessible = Market.solve_y_for_x(x, first_x, first_y, second_x, second_y)
    if accessible && !accessible.nan?
      accessible = [accessible, 0].max
      accessible = accessible.round
      max_sales = max_capacity * Company.get_capacity_of_launch(type, level)
      sales_made = [accessible, max_sales].min
      return sales_made * price
    else
      return 0
    end
  end

   #Method used for drawing the test graphs for markets
  def self.get_test_sales(price, max_capacity, level, type, market)
    graph_values = market.get_graph_values(level, type)
    sweet_spot_customers = graph_values[0]
    sweet_spot_price = graph_values[1]
    max_price = graph_values[2]
    max_customers = graph_values[3]
    if price > sweet_spot_price
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
    x = price
    accessible = Market.solve_y_for_x(x, first_x, first_y, second_x, second_y)
    if accessible && !accessible.nan?
      accessible = [accessible, 0].max
      accessible = accessible.round
      max_sales = max_capacity * Company.get_capacity_of_launch(type, level)
      sales_made = [accessible, max_sales].min
      return sales_made
    else
      return 0
    end
  end

  #Get launches for the test company
  def self.get_test_launches(company, sales, max_cap)
    if company.product_type == 1
      max_customers = max_cap * Company.get_capacity_of_launch(company.product_type, company.service_level)
      if max_customers == 0
        return 0
      end
      perc = ((sales.to_f / max_customers.to_f) * 100).to_i
      if perc >= 80         #If capacity utilization is at least 80%, are launches are made
        return max_cap
      elsif perc >= 60    # If utilization is between 60 and 80%, then 90% of launches are made
        return (max_cap * 0.9).to_i
      elsif perc >= 40    # If utilization is between 40% and 60%, then 70% of the launches are made
        return (max_cap * 0.7).to_i
      elsif perc >= 20    # If utilization is between 20% and 40%, then 50% of the launches are made
        return (max_cap * 0.5).to_i
      else                      # If utilization is under 20%, return the lowest amount of launches needed to fly all customers
        if sales % Company.get_capacity_of_launch(company.product_type, company.service_level) == 0
          return sales / Company.get_capacity_of_launch(company.product_type, company.service_level)
        else
          return sales / Company.get_capacity_of_launch(company.product_type, company.service_level) + 1
        end
      end
    else

      return (sales.to_f / Company.get_capacity_of_launch(company.product_type, company.service_level)).ceil
    end
  end



  #Returns a table with following values [SWEET_SPOT_CUSTOMERS, SWEET_SPOT_PRICE, MAX_PRICE, MAX_CUSTOMERS, SATISFACTION_WEIGHT]
  def get_graph_values(level, type)
    graph_values = []
    if (level == 1 && type == 1)
      graph_values << self.lb_amount
      graph_values << self.lb_sweet_price
      graph_values << self.lb_max_price
      graph_values << self.lb_max_customers
      graph_values << self.lb_satisfaction_weight
    elsif (level == 3 && type == 1)
      graph_values << self.ll_amount
      graph_values << self.ll_sweet_price
      graph_values << self.ll_max_price
      graph_values << self.ll_max_customers
      graph_values << self.ll_satisfaction_weight
    elsif (level == 1 && type == 3)
      graph_values << self.hb_amount
      graph_values << self.hb_sweet_price
      graph_values << self.hb_max_price
      graph_values << self.hb_max_customers
      graph_values << self.hb_satisfaction_weight
    else
      graph_values << self.hl_amount
      graph_values << self.hl_sweet_price
      graph_values << self.hl_max_price
      graph_values << self.hl_max_customers
      graph_values << self.hl_satisfaction_weight
    end
    graph_values
  end

  def get_satisfaction_limits(type, level)
    limits = []
    sign = type.to_s + level.to_s + "_"
    limits << self.satisfaction_limits[sign + "l"].to_f
    limits << self.satisfaction_limits[sign + "e"].to_f
    limits << self.satisfaction_limits[sign + "b"].to_f
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



  def self.benchmark
    game = Game.get_game
    puts Benchmark.measure { game.end_sub_round }
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
    k = (second_y - first_y).to_f / (second_x - first_x)
    puts k
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

  def self.get_market_news
    markets = Market.all
    news = ""
    markets.each do |m|
      message = (m.message && !m.message.blank?) ? m.message : "Nothing to report"
      news +=  m.name + ":\n" + message + "\n\n"
    end
    return news.html_safe
  end

  def generate_news
    news = ""
    news << budget_hop_changed
    news << luxury_hop_changed
    news << budget_cruise_changed
    news << luxury_cruise_changed
    return news
  end

  private

    def budget_hop_changed
      change = ""
      if self.lb_amount_changed? || self.lb_sweet_price_changed? || self.lb_max_price_changed? || self.lb_max_customers_changed?
        change << "\nChanged in the Budget Space Hop Sector:\n\n"

        if self.lb_amount_changed? || self.lb_max_customers_changed?
          if self.lb_amount_was > self.lb_amount || self.lb_max_customers_was > self.lb_max_customers
            change << "Market has become smaller, there are not as many customers available.\n"
          else
            change << "Market has grown larger, there are more customers available.\n"
          end
        end

         if self.lb_sweet_price_changed? || self.lb_max_price_changed?
          if self.lb_sweet_price_was > self.lb_sweet_price || self.lb_max_price_was > self.lb_max_price
            change << "Market has become poorer. People are not ready to spend as much money as before.\n"
          else
            change << "Market has become richer. People are ready to spend more money.\n"
          end
        end

      end
      return change
    end

    def budget_cruise_changed
      change = ""
      if self.hb_amount_changed? || self.hb_sweet_price_changed? || self.hb_max_price_changed? || self.hb_max_customers_changed?
        change << "\nChanged in the Budget Space Station Visit Sector:\n\n"

        if self.hb_amount_changed? || self.hb_max_customers_changed?
          if self.hb_amount_was > self.hb_amount || self.hb_max_customers_was > self.hb_max_customers
            change << "Market has become smaller, there are not as many customers available.\n"
          else
            change << "Market has grown larger, there are more customers available.\n"
          end
        end

         if self.hb_sweet_price_changed? || self.hb_max_price_changed?
          if self.hb_sweet_price_was > self.hb_sweet_price || self.hb_max_price_was > self.hb_max_price
            change << "Market has become poorer. People are not ready to spend as much money as before.\n"
          else
            change << "Market has become richer. People are ready to spend more money.\n"
          end
        end

      end
      return change
    end
    
    def luxury_hop_changed
      change = ""
      if self.ll_amount_changed? || self.ll_sweet_price_changed? || self.ll_max_price_changed? || self.ll_max_customers_changed?
        change << "\nChanged in the Luxury Space Hop Sector:\n\n"

        if self.ll_amount_changed? || self.ll_max_customers_changed?
          if self.ll_amount_was > self.ll_amount || self.ll_max_customers_was > self.ll_max_customers
            change << "Market has become smaller, there are not as many customers available.\n"
          else
            change << "Market has grown larger, there are more customers available.\n"
          end
        end

         if self.ll_sweet_price_changed? || self.ll_max_price_changed?
          if self.ll_sweet_price_was > self.ll_sweet_price || self.ll_max_price_was > self.ll_max_price
            change << "Market has become poorer. People are not ready to spend as much money as before.\n"
          else
            change << "Market has become richer. People are ready to spend more money.\n"
          end
        end

      end
      return change
    end
    
    def luxury_cruise_changed
      change = ""
      if self.hl_amount_changed? || self.hl_sweet_price_changed? || self.hl_max_price_changed? || self.hl_max_customers_changed?
        change << "\nChanged in the Luxury Space Station Visit Sector:\n\n"

        if self.hl_amount_changed? || self.hl_max_customers_changed?
          if self.hl_amount_was > self.hl_amount || self.hl_max_customers_was > self.hl_max_customers
            change << "Market has become smaller, there are not as many customers available.\n"
          else
            change << "Market has grown larger, there are more customers available.\n"
          end
        end

         if self.hl_sweet_price_changed? || self.hl_max_price_changed?
          if self.hl_sweet_price_was > self.hl_sweet_price || self.hl_max_price_was > self.hl_max_price
            change << "Market has become poorer. People are not ready to spend as much money as before.\n"
          else
            change << "Market has become richer. People are ready to spend more money.\n"
          end
        end

      end
      return change
    end




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
