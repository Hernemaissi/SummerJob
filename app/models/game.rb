# == Schema Information
#
# Table name: games
#
#  id                           :integer          not null, primary key
#  current_round                :integer          default(1)
#  max_rounds                   :integer          default(3)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  sub_round                    :integer          default(1)
#  calculating                  :boolean          default(FALSE)
#  finished                     :boolean          default(FALSE)
#  results_published            :boolean          default(TRUE)
#  low_budget_min_operator      :decimal(, )      default(1000.0)
#  low_budget_max_operator      :decimal(, )      default(2000.0)
#  low_budget_cap_operator      :integer          default(20)
#  high_budget_min_operator     :decimal(, )      default(3000.0)
#  high_budget_max_operator     :decimal(, )      default(5000.0)
#  high_budget_cap_operator     :integer          default(40)
#  low_luxury_min_operator      :decimal(, )      default(10000.0)
#  low_luxury_max_operator      :decimal(, )      default(20000.0)
#  low_luxury_cap_operator      :integer          default(10)
#  high_luxury_min_operator     :decimal(, )      default(50000.0)
#  high_luxury_max_operator     :decimal(, )      default(100000.0)
#  high_luxury_cap_operator     :integer          default(5)
#  low_budget_var_max_operator  :decimal(, )      default(20000.0)
#  low_luxury_var_max_operator  :decimal(, )      default(30000.0)
#  high_budget_var_max_operator :decimal(, )      default(50000.0)
#  high_luxury_var_max_operator :decimal(, )      default(80000.0)
#  low_budget_var_min_operator  :decimal(, )      default(10000.0)
#  low_luxury_var_min_operator  :decimal(, )      default(15000.0)
#  high_budget_var_min_operator :decimal(, )      default(20000.0)
#  high_luxury_var_min_operator :decimal(, )      default(30000.0)
#  low_budget_min_customer      :decimal(, )      default(1000.0)
#  low_budget_max_customer      :decimal(, )      default(2000.0)
#  low_budget_cap_customer      :integer          default(20)
#  high_budget_min_customer     :decimal(, )      default(3000.0)
#  high_budget_max_customer     :decimal(, )      default(5000.0)
#  high_budget_cap_customer     :integer          default(40)
#  low_luxury_min_customer      :decimal(, )      default(10000.0)
#  low_luxury_max_customer      :decimal(, )      default(20000.0)
#  low_luxury_cap_customer      :integer          default(10)
#  high_luxury_min_customer     :decimal(, )      default(50000.0)
#  high_luxury_max_customer     :decimal(, )      default(100000.0)
#  high_luxury_cap_customer     :integer          default(5)
#  low_budget_var_max_customer  :decimal(, )      default(20000.0)
#  low_luxury_var_max_customer  :decimal(, )      default(30000.0)
#  high_budget_var_max_customer :decimal(, )      default(50000.0)
#  high_luxury_var_max_customer :decimal(, )      default(80000.0)
#  low_budget_var_min_customer  :decimal(, )      default(10000.0)
#  low_luxury_var_min_customer  :decimal(, )      default(15000.0)
#  high_budget_var_min_customer :decimal(, )      default(20000.0)
#  high_luxury_var_min_customer :decimal(, )      default(30000.0)
#  low_budget_min_tech          :decimal(, )      default(1000.0)
#  low_budget_max_tech          :decimal(, )      default(2000.0)
#  low_budget_cap_tech          :integer          default(20)
#  high_budget_min_tech         :decimal(, )      default(3000.0)
#  high_budget_max_tech         :decimal(, )      default(5000.0)
#  high_budget_cap_tech         :integer          default(40)
#  low_luxury_min_tech          :decimal(, )      default(10000.0)
#  low_luxury_max_tech          :decimal(, )      default(20000.0)
#  low_luxury_cap_tech          :integer          default(10)
#  high_luxury_min_tech         :decimal(, )      default(50000.0)
#  high_luxury_max_tech         :decimal(, )      default(100000.0)
#  high_luxury_cap_tech         :integer          default(5)
#  low_budget_var_max_tech      :decimal(, )      default(20000.0)
#  low_luxury_var_max_tech      :decimal(, )      default(30000.0)
#  high_budget_var_max_tech     :decimal(, )      default(50000.0)
#  high_luxury_var_max_tech     :decimal(, )      default(80000.0)
#  low_budget_var_min_tech      :decimal(, )      default(10000.0)
#  low_luxury_var_min_tech      :decimal(, )      default(15000.0)
#  high_budget_var_min_tech     :decimal(, )      default(20000.0)
#  high_luxury_var_min_tech     :decimal(, )      default(30000.0)
#  low_budget_min_supply        :decimal(, )      default(1000.0)
#  low_budget_max_supply        :decimal(, )      default(2000.0)
#  low_budget_cap_supply        :integer          default(20)
#  high_budget_min_supply       :decimal(, )      default(3000.0)
#  high_budget_max_supply       :decimal(, )      default(5000.0)
#  high_budget_cap_supply       :integer          default(40)
#  low_luxury_min_supply        :decimal(, )      default(10000.0)
#  low_luxury_max_supply        :decimal(, )      default(20000.0)
#  low_luxury_cap_supply        :integer          default(10)
#  high_luxury_min_supply       :decimal(, )      default(50000.0)
#  high_luxury_max_supply       :decimal(, )      default(100000.0)
#  high_luxury_cap_supply       :integer          default(5)
#  low_budget_var_max_supply    :decimal(, )      default(20000.0)
#  low_luxury_var_max_supply    :decimal(, )      default(30000.0)
#  high_budget_var_max_supply   :decimal(, )      default(50000.0)
#  high_luxury_var_max_supply   :decimal(, )      default(80000.0)
#  low_budget_var_min_supply    :decimal(, )      default(10000.0)
#  low_luxury_var_min_supply    :decimal(, )      default(15000.0)
#  high_budget_var_min_supply   :decimal(, )      default(20000.0)
#  high_luxury_var_min_supply   :decimal(, )      default(30000.0)
#  variable_hash                :text
#  sub_round_decided            :boolean
#  sign_up_open                 :boolean          default(TRUE)
#  bonus_hash                   :text
#

#The Game model is currently a singleton controlling the whole game (see get_game method)
#In the future there might be multiple games running simultaneously

class Game < ActiveRecord::Base
  has_paper_trail :only => [:sub_round]
 
  serialize :variable_hash, Hash
  serialize :bonus_hash, Hash
  has_many :networks
  
  validates :current_round, presence: true
  validates :max_rounds, presence: true
  validate :validate_smaller_than

  parsed_fields :low_budget_min_operator, :low_budget_max_operator, :low_budget_cap_operator ,:high_budget_min_operator, :high_budget_max_operator,
:high_budget_cap_operator, :low_luxury_min_operator, :low_luxury_max_operator, :low_luxury_cap_operator, :high_luxury_min_operator,
:high_luxury_max_operator, :high_luxury_cap_operator, :low_budget_var_max_operator, :low_luxury_var_max_operator, :high_budget_var_max_operator,
:high_luxury_var_max_operator, :low_budget_var_min_operator, :low_luxury_var_min_operator, :high_budget_var_min_operator,
:high_luxury_var_min_operator, :low_budget_min_customer, :low_budget_max_customer, :low_budget_cap_customer, :high_budget_min_customer,
:high_budget_max_customer, :high_budget_cap_customer, :low_luxury_min_customer, :low_luxury_max_customer, :low_luxury_cap_customer,
:high_luxury_min_customer, :high_luxury_max_customer, :high_luxury_cap_customer, :low_budget_var_max_customer,
:low_luxury_var_max_customer, :high_budget_var_max_customer, :high_luxury_var_max_customer, :low_budget_var_min_customer,
:low_luxury_var_min_customer, :high_budget_var_min_customer, :high_luxury_var_min_customer, :low_budget_min_tech,
:low_budget_max_tech, :low_budget_cap_tech, :high_budget_min_tech, :high_budget_max_tech, :high_budget_cap_tech,
:low_luxury_min_tech, :low_luxury_max_tech, :low_luxury_cap_tech, :high_luxury_min_tech, :high_luxury_max_tech,
:high_luxury_cap_tech, :low_budget_var_max_tech, :low_luxury_var_max_tech, :high_budget_var_max_tech, :high_luxury_var_max_tech,
:low_budget_var_min_tech, :low_luxury_var_min_tech, :high_budget_var_min_tech, :high_luxury_var_min_tech,
:low_budget_min_supply, :low_budget_max_supply, :low_budget_cap_supply, :high_budget_min_supply, :high_budget_max_supply,
:high_budget_cap_supply, :low_luxury_min_supply, :low_luxury_max_supply, :low_luxury_cap_supply, :high_luxury_min_supply,
:high_luxury_max_supply, :high_luxury_cap_supply, :low_budget_var_max_supply, :low_luxury_var_max_supply, :high_budget_var_max_supply,
:high_luxury_var_max_supply, :low_budget_var_min_supply, :low_luxury_var_min_supply, :high_budget_var_min_supply, :high_luxury_var_min_supply,


  #Returns the objective of the current round as a string.
  def get_round_objective
    if current_round == 1
      "The objective of Round 1 is to have a Business plan and complete the Business Model Canvas for your company."
    elsif current_round == 2
      "The objective of Round 2 is to create contracts between all the companies that you need or need you. If you are customer facing company, you must also decide the product sell price and target market."
    else
      "Make money"
    end
  end

  #Returns the singleton game model, or creates it if it doesn't exist
  def self.get_game
    game = Game.first
    unless game
      game = Game.create
      game.save
    end
    game
  end

 
  #Calculates the amount of sales made by each network
  def calculate_sales
    markets = Market.all
    markets.each do |m|
      m.complete_sales
    end
  end

  #Ends the current sub-round (aka fiscal year), calculating all the results and moving to next sub-round
  def end_sub_round
    self.update_attribute(:calculating, true)
    Company.set_update_flag(true)
    PaperTrail.enabled = false
    Company.reset_profit
    Company.reset_launches_made #Combine with reset_profit
    self.calculate_sales
    Risk.apply_risks
    Company.save_launches
    Company.calculate_results
    CustomerFacingRole.apply_risk_penalties
    self.results_published = false
    self.sub_round_decided = false
    Game.store_company_reports
    CustomerFacingRole.generate_reports
    Company.reset_extras
    Company.update_choices
    Company.set_update_flag(false)
    PaperTrail.enabled = true
    self.sub_round += 1
    self.save!
  end

  #Returns the total amount of customers in the whole game
  def total_customers
    total = 0
    markets = Market.all
    markets.each do |m|
      total += m.customer_amount
    end
    total
  end

  #Loops through all companies and creates a yearly report for them
  def self.store_company_reports
    Company.all.each do |c|
      c.create_report
    end
  end


  def in_round(round)
    self.current_round == round
  end
 

  def test_values(market_id, type, level, customer_sat)
    bubble_table = []
    bubble_table << ['Utilization', 'Launches', 'Price', 'Profit', 'Profit(abs)']
    begin
      market = Market.find(market_id)
      max_price = market.get_graph_values(level, type)[2]
      price_step = max_price / 5
      start_price = 0
      companies = create_test_companies(market_id, type, level, customer_sat)
      min_cap_company = companies.min_by { |c| c.calculate_capacity_limit(level, type, c) }
      max_cap = min_cap_company.calculate_capacity_limit(level, type, min_cap_company)
      cap_step = max_cap / 5
      start_cap = 0
      puts "Cap Step: #{cap_step}"
      puts "max_cap: #{max_cap}"
      puts "Price step: #{price_step}"

      if price_step <= 0
        puts "market values not properly set, terminating"
        return []
      end

      while start_price <= max_price
        while start_cap <= max_cap

          companies.each do |company|
            company.max_capacity = start_cap
            company.capacity_cost = company.calculate_capacity_cost(start_cap)
          end

          customer_company = companies[0]
          customer_company.role.sell_price = start_price
          customer_company.save(validate: false)
          customer_company.role.save(validate: false)
          puts "Price in the main method: #{customer_company.role.sell_price}"
          customer_company.role.sales_made = customer_company.role.market.simulate_sales(customer_company.role, start_cap)
          puts "Sales made: #{customer_company.role.sales_made}"
          launches = customer_company.role.get_launches(start_cap)
          if launches == 0
            utilization = 0
          else
            if (start_cap == 360 || start_cap == 480) && start_price == 270000
              puts "Sales made: #{customer_company.role.sales_made}"
              puts "launches: #{launches}"
            end
            utilization = (customer_company.role.sales_made.to_f / (launches * Company.get_capacity_of_launch(customer_company.product_type, customer_company.service_level) ) * 100).round
          end
          revenue = customer_company.role.sales_made *  customer_company.role.sell_price
          total_cost = 0
          puts "Launches: #{0}"
          companies.each do |company|
            puts "Capacity cost: #{company.capacity_cost}"
            puts "Variable cost: #{company.variable_cost}"
            total_cost += company.capacity_cost * 2 + company.variable_cost * launches
          end
          profit = revenue - total_cost
          if start_cap > 0 && start_price > 0
            bubble_table << [utilization.to_s, start_cap, start_price.to_i, profit.to_i, profit.to_i.abs]
          else
            bubble_table << ["", start_cap, start_price.to_i, profit.to_i, 0]
          end
          start_cap += cap_step
        end
        start_price += price_step
        start_cap = 0
      end

    rescue => e
      puts "We hit an error"
      puts e.message
      puts e.backtrace
    ensure
      companies.each do |c|
        c.destroy
      end
    end

    bubble_table

  end

  private

  def create_test_companies(market_id, type, level, customer_sat)
    companies = []
    for i in 0..3
      company = Company.create(:service_type => Company.types[i])
      company.create_role
      company.role.service_level = level
      company.role.product_type = type
      company.role.market_id = market_id if company.is_customer_facing?
      company.variable_cost = company.get_variable_cost(customer_sat)
      company.role.last_satisfaction = customer_sat if company.is_customer_facing?
      company.role.save
      companies << company
    end
    companies
  end

  #Validates that the first column is smaller than the second column
  def smaller_than(first_column, second_column)
    puts "First:" + self[first_column].to_f.to_s
    puts  "Second:" + self[second_column].to_f.to_s
    if self[first_column] <= self[second_column]
       return true
    end
    return false
  end

  def validate_smaller_than
    print "Smaller than return value: " + smaller_than(:low_budget_min_operator, :low_budget_max_operator).to_s
     if !smaller_than(:low_budget_min_operator, :low_budget_max_operator)
        errors.add(:low_budget_min_operator, "Min value cannot be larger than max value")
     end
     if !smaller_than(:low_budget_var_min_operator, :low_budget_var_max_operator)
        errors.add(:low_budget_var_min_operator, "Min value cannot be larger than max value")
     end

     if !smaller_than(:high_budget_min_operator, :high_budget_max_operator)
        errors.add(:high_budget_min_operator, "Min value cannot be larger than max value")
     end
     if !smaller_than(:high_budget_var_min_operator, :high_budget_var_max_operator)
        errors.add(:high_budget_var_min_operator, "Min value cannot be larger than max value")
     end

     if !smaller_than(:low_luxury_min_operator, :low_luxury_max_operator)
        errors.add(:low_luxury_min_operator, "Min value cannot be larger than max value")
     end
     if !smaller_than(:low_luxury_var_min_operator, :low_luxury_var_max_operator)
        errors.add(:low_luxury_var_min_operator, "Min value cannot be larger than max value")
     end

     if !smaller_than(:high_luxury_min_operator, :high_luxury_max_operator)
        errors.add(:high_luxury_min_operator, "Min value cannot be larger than max value")
     end
     if !smaller_than(:high_luxury_var_min_operator, :high_luxury_var_max_operator)
        errors.add(:high_luxury_var_min_operator, "Min value cannot be larger than max value")
     end



     if !smaller_than(:low_budget_min_customer, :low_budget_max_customer)
        errors.add(:low_budget_min_customer, "Min value cannot be larger than max value")
     end
     if !smaller_than(:low_budget_var_min_customer, :low_budget_var_max_customer)
        errors.add(:low_budget_var_min_customer, "Min value cannot be larger than max value")
     end

     if !smaller_than(:high_budget_min_customer, :high_budget_max_customer)
        errors.add(:high_budget_min_customer, "Min value cannot be larger than max value")
     end
     if !smaller_than(:high_budget_var_min_customer, :high_budget_var_max_customer)
        errors.add(:high_budget_var_min_customer, "Min value cannot be larger than max value")
     end

     if !smaller_than(:low_luxury_min_customer, :low_luxury_max_customer)
        errors.add(:low_luxury_min_customer, "Min value cannot be larger than max value")
     end
     if !smaller_than(:low_luxury_var_min_customer, :low_luxury_var_max_customer)
        errors.add(:low_luxury_var_min_customer, "Min value cannot be larger than max value")
     end

     if !smaller_than(:high_luxury_min_customer, :high_luxury_max_customer)
        errors.add(:high_luxury_min_customer, "Min value cannot be larger than max value")
     end
     if !smaller_than(:high_luxury_var_min_customer, :high_luxury_var_max_customer)
        errors.add(:high_luxury_var_min_customer, "Min value cannot be larger than max value")
     end


     if !smaller_than(:low_budget_min_tech, :low_budget_max_tech)
        errors.add(:low_budget_min_tech, "Min value cannot be larger than max value")
     end
     if !smaller_than(:low_budget_var_min_tech, :low_budget_var_max_tech)
        errors.add(:low_budget_var_min_tech, "Min value cannot be larger than max value")
     end

     if !smaller_than(:high_budget_min_tech, :high_budget_max_tech)
        errors.add(:high_budget_min_tech, "Min value cannot be larger than max value")
     end
     if !smaller_than(:high_budget_var_min_tech, :high_budget_var_max_tech)
        errors.add(:high_budget_var_min_tech, "Min value cannot be larger than max value")
     end

     if !smaller_than(:low_luxury_min_tech, :low_luxury_max_tech)
        errors.add(:low_luxury_min_tech, "Min value cannot be larger than max value")
     end
     if !smaller_than(:low_luxury_var_min_tech, :low_luxury_var_max_tech)
        errors.add(:low_luxury_var_min_tech, "Min value cannot be larger than max value")
     end

     if !smaller_than(:high_luxury_min_tech, :high_luxury_max_tech)
        errors.add(:high_luxury_min_tech, "Min value cannot be larger than max value")
     end
     if !smaller_than(:high_luxury_var_min_tech, :high_luxury_var_max_tech)
        errors.add(:high_luxury_var_min_tech, "Min value cannot be larger than max value")
     end



     if !smaller_than(:low_budget_min_supply, :low_budget_max_supply)
        errors.add(:low_budget_min_supply, "Min value cannot be larger than max value")
     end
     if !smaller_than(:low_budget_var_min_supply, :low_budget_var_max_supply)
        errors.add(:low_budget_var_min_supply, "Min value cannot be larger than max value")
     end

     if !smaller_than(:high_budget_min_supply, :high_budget_max_supply)
        errors.add(:high_budget_min_supply, "Min value cannot be larger than max value")
     end
     if !smaller_than(:high_budget_var_min_supply, :high_budget_var_max_supply)
        errors.add(:high_budget_var_min_supply, "Min value cannot be larger than max value")
     end

     if !smaller_than(:low_luxury_min_supply, :low_luxury_max_supply)
        errors.add(:low_luxury_min_supply, "Min value cannot be larger than max value")
     end
     if !smaller_than(:low_luxury_var_min_supply, :low_luxury_var_max_supply)
        errors.add(:low_luxury_var_min_supply, "Min value cannot be larger than max value")
     end

     if !smaller_than(:high_luxury_min_supply, :high_luxury_max_supply)
        errors.add(:high_luxury_min_supply, "Min value cannot be larger than max value")
     end
     if !smaller_than(:high_luxury_var_min_supply, :high_luxury_var_max_supply)
        errors.add(:high_luxury_var_min_supply, "Min value cannot be larger than max value")
     end
  end
  
end
