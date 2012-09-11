#The Game model is currently a singleton controlling the whole game (see get_game method)
#In the future there might be multiple games running simultaneously

class Game < ActiveRecord::Base
  attr_accessible :current_round, :max_rounds, :low_budget_min,:low_budget_max,:low_budget_cap,:high_budget_min,:high_budget_max,:high_budget_cap,:low_luxury_min,:low_luxury_max, :low_luxury_cap, :high_luxury_min,:high_luxury_max,:high_luxury_cap, :low_budget_var_max, :low_luxury_var_max, :high_budget_var_max, :high_luxury_var_max, :low_budget_var_min, :low_luxury_var_min, :high_budget_var_min, :high_luxury_var_min
  
  has_many :networks
  
  validates :current_round, presence: true
  validates :max_rounds, presence: true

  #Returns the objective of the current round as a string.
  def get_round_objective
    if current_round == 1
      "The objective of Round 1 is to have a business plan for your company that has been verified by the teacher."
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
    #self.calculating = true
    #self.save!
    Network.reset_sales
    Company.reset_profit
    self.calculate_sales
    Network.calculate_revenue
    Risk.apply_risks
    extras = Company.calculate_profit
    Network.calculate_score
    self.sub_round += 1
    self.calculating = false
    self.results_published = false
    self.save!
    Game.store_company_reports(extras)
    Game.store_network_reports
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
  #Takes a hash containing the extra costs of all companies as parameter
  def self.store_company_reports(extras)
    Company.all.each do |c|
      c.create_report(extras[c.id])
    end
  end

  #Loops through companies and creates yearly reports for them
  def self.store_network_reports
    Network.all.each do |n|
      n.create_report
    end
  end
  
end
# == Schema Information
#
# Table name: games
#
#  id                  :integer         not null, primary key
#  current_round       :integer         default(1)
#  max_rounds          :integer         default(3)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  sub_round           :integer         default(1)
#  calculating         :boolean         default(FALSE)
#  finished            :boolean         default(FALSE)
#  results_published   :boolean         default(TRUE)
#  low_budget_min      :decimal(, )     default(1000.0)
#  low_budget_max      :decimal(, )     default(2000.0)
#  low_budget_cap      :integer         default(20)
#  high_budget_min     :decimal(, )     default(3000.0)
#  high_budget_max     :decimal(, )     default(5000.0)
#  high_budget_cap     :integer         default(40)
#  low_luxury_min      :decimal(, )     default(10000.0)
#  low_luxury_max      :decimal(, )     default(20000.0)
#  low_luxury_cap      :integer         default(10)
#  high_luxury_min     :decimal(, )     default(50000.0)
#  high_luxury_max     :decimal(, )     default(100000.0)
#  high_luxury_cap     :integer         default(5)
#  low_budget_var_max  :decimal(, )     default(20000.0)
#  low_luxury_var_max  :decimal(, )     default(30000.0)
#  high_budget_var_max :decimal(, )     default(50000.0)
#  high_luxury_var_max :decimal(, )     default(80000.0)
#  low_budget_var_min  :decimal(, )     default(10000.0)
#  low_luxury_var_min  :decimal(, )     default(15000.0)
#  high_budget_var_min :decimal(, )     default(20000.0)
#  high_luxury_var_min :decimal(, )     default(30000.0)
#

