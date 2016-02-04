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
#  office                 :text
#  test                   :boolean          default(FALSE)
#



class Market < ActiveRecord::Base
  require 'benchmark'
  attr_accessible :name, :customer_amount, :price_sensitivity,
    :min_satisfaction, :expected_satisfaction, :max_satisfaction_bonus, :base_price, :message, :variables, :lb_satisfaction_weight, :interest,
    :payback_per, :expansion_cost, :office
  
  serialize :satisfaction_limits, Hash
  serialize :variables, Hash
  has_many :customer_facing_roles
  has_many :roles
  belongs_to :risk
  
  

  parsed_fields :customer_amount, :price_sensitivity, :base_price, :variables, :expansion_cost


  validates :name, presence: true

  #Returns the amount of sales the network makes
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

  def test_sales(price, launches, company)
    marketing = company.role.marketing
    mark1 = self.variables["mark1"].to_f
    mark2 = self.variables["mark2"].to_f
    accessible = [self.customer_amount, (self.customer_amount / 2 - mark2)*Math.sqrt(marketing/mark1) + mark2].min 
    sat = Network.get_weighted_satisfaction(company.role, price)
    puts "accessible: #{accessible}"
    puts "sat: #{sat}"
    sales = [accessible * sat, self.customer_amount].min.floor
    puts "Sales: #{sales}"
    capacity = Company.local_network(company).reject! {|c| !c.company_type.capacity_produce}.first.role.unit_size
    max_sales =  launches * capacity
    sales_made = [sales, max_sales].min
    company.role.sales_made = sales_made
    actual_launches = company.role.get_launches(launches, max_sales)
    costs = company.test_network_cost(actual_launches)
    return sales_made * price - costs
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
  
  def office_in
    unless !self.office || self.office.empty?
      return self.office
    else
      return "Unknown location"
    end
  end

  def self.copy_market(source_id, destination_id)
    source = Market.find(source_id)
    destination = Market.find(destination_id)
    destination.variables = source.variables
    destination.customer_amount = source.customer_amount
    destination.lb_satisfaction_weight = source.lb_satisfaction_weight
    destination.save!
  end

  private

 
end
