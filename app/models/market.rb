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
#  price_sensitivity      :decimal(, )
#  variables              :text
#  interest               :integer
#  payback_per            :integer
#  expansion_cost         :decimal(20, 2)   default(0.0)
#



class Market < ActiveRecord::Base
  require 'benchmark'
  attr_accessible :name, :customer_amount, :price_sensitivity,
    :min_satisfaction, :expected_satisfaction, :max_satisfaction_bonus, :base_price, :message, :variables, :lb_satisfaction_weight, :interest,
    :payback_per, :expansion_cost
  
  serialize :satisfaction_limits, Hash
  serialize :variables, Hash
  has_many :customer_facing_roles
  has_many :roles
  belongs_to :risk
  
  

  parsed_fields :customer_amount, :price_sensitivity, :base_price, :variables, :expansion_cost


  validates :name, presence: true

  #Returns the amount of sales the network makes
#TODO Higher than customer amount?
  def get_sales(customer_role)
    marketing = customer_role.company.network_marketing
    mark1 = self.variables["mark1"].to_f
    mark2 = self.variables["mark2"].to_f
    accessible = [self.customer_amount, (self.customer_amount / 2 - mark2)*Math.sqrt(marketing/mark1) + mark2].min
    sat = Network.get_weighted_satisfaction(customer_role)
    return [accessible * sat, self.customer_amount].min.floor
  end

  
  #Completes the sale for every company
  def complete_sales
    shares = self.market_share
    self.roles.each do |c|
      if c.company.is_customer_facing? && c.company.network_ready?
        type = "t"
        if shares[c.id] && shares[c.id] != 0
          company_share_per = shares[c.id].to_f / shares[type].to_f
          sales_made = company_share_per * shares["b"]
 
          sales_made = shares[c.id] if shares[c.id] < sales_made
        else
          sales_made = 0
        end
        
        max_sales =  c.company.network_max_customers
        sales_made = [sales_made, max_sales].min
        puts "sales_made: #{sales_made}"
        c.update_attribute(:sales_made, sales_made)
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

  

  #Calculates the market share
  #Param: If set to true, ignores the part_of_network check, used when simulating results
  def market_share(simulated = false)
    shares = {}
    shares["t"] = 0
    shares["b"] = 0
    self.roles.each do |c|
      if (c.company.is_customer_facing? && c.company.network_ready?)
        sales = self.get_sales(c)
        shares[c.id] = sales
        shares["t"] += sales
        shares["b"] = sales if sales > shares["b"]
      end
    end
    return shares
  end

  def market_test(customer_role, companies)
    test_sat = Network.test_network_satisfaction_weighted(customer_role, companies)
    test_costs = Network.test_network_costs(companies)
    
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



  

  def get_satisfaction_limits(type, level)
    limits = []
    sign = type.to_s + level.to_s + "_"
    limits << self.satisfaction_limits[sign + "l"].to_f
    limits << self.satisfaction_limits[sign + "e"].to_f
    limits << self.satisfaction_limits[sign + "b"].to_f
  end


 


  def self.benchmark
    game = Game.get_game
    puts Benchmark.measure { game.end_sub_round }
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

  def self.parse_variables(string)
    vars = {}
    string.each_line do |line|
      comment = line.split("%", 2)[1] if line.split("%", 2).size == 2
      values = line.split("%", 2).first.strip.tr(";", "").split("=")
      if values.size < 2
        next
      end
      vars[values[0]] = values[1]
      comment_key = values[0] + "_comment"
      vars[comment_key] = comment
    end
    return vars
  end

  def average_price
    avg_price = 0
    t_customers = 0
    self.roles.each do |r|
      t_customers += r.sales_made
      sell_price = (r.sell_price != nil) ? r.sell_price : 0
      avg_price += r.sales_made * sell_price
    end
    return 0 if t_customers == 0
    return (avg_price.to_f / t_customers.to_f).round
  end

  def average_satisfaction
    avg_sat = 0
    t_roles = self.roles.size
    self.roles.each do |r|
      sat = 0
      sat = r.last_satisfaction unless r.last_satisfaction.nil?
      avg_sat += sat
    end
    return 0 if t_roles == 0
    return (avg_sat.to_f / t_roles.to_f * 100).round
  end

  def t_customers
    t_customers = 0
    self.roles.each do |r|
      t_customers += r.sales_made
    end
    return t_customers
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

 
  
end
