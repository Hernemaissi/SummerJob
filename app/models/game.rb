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
#

#The Game model is currently a singleton controlling the whole game (see get_game method)
#In the future there might be multiple games running simultaneously

class Game < ActiveRecord::Base
 
  serialize :variable_hash, Hash
  has_many :networks
  
  validates :current_round, presence: true
  validates :max_rounds, presence: true


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
    Company.reset_profit
    Company.reset_launches_made #Combine with reset_profit
    self.calculate_sales
    Company.save_launches
    Company.calculate_results
    Contract.update_contracts
    self.sub_round += 1
    self.calculating = false
    self.results_published = false
    self.save!
    Game.store_company_reports
    Company.reset_extras
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
  def self.store_company_reports
    Company.all.each do |c|
      c.create_report
    end
  end

  #Loops through companies and creates yearly reports for them
  def self.store_network_reports
    Network.all.each do |n|
      n.create_report
    end
  end
  
end
