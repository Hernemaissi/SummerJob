#The Game model is currently a singleton controlling the whole game (see get_game method)
#In the future there might be multiple games running simultaneously

class Game < ActiveRecord::Base
  attr_accessible :current_round, :max_rounds
  
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
    total = self.total_customers
    current_progress = 0
    markets.each do |m|
      customers = m.complete_sales(current_progress, total, self)
      current_progress += customers.size
    end
  end

  #Ends the current sub-round (aka fiscal year), calculating all the results and moving to next sub-round
  def end_sub_round
    #self.calculating = true
    #self.save!
    Game.store_company_reports
    Game.store_network_reports
    Network.reset_sales
    Company.reset_profit
    self.calculate_sales
    Network.calculate_revenue
    Risk.apply_risks
    Company.calculate_profit
    Network.calculate_score
    Market.apply_effects
    self.sub_round += 1
    self.calculating = false
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
#  id            :integer         not null, primary key
#  current_round :integer         default(1)
#  max_rounds    :integer         default(3)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  sub_round     :integer         default(1)
#  calculating   :boolean         default(FALSE)
#  finished      :boolean         default(FALSE)
#

