class Game < ActiveRecord::Base
  attr_accessible :current_round, :max_rounds
  
  has_many :networks
  
  validates :current_round, presence: true
  validates :max_rounds, presence: true
  
  def get_round_objective
    if current_round == 1
      "The objective of Round 1 is to have a business plan for your company that has been verified by the teacher."
    elsif current_round == 2
      "The objective of Round 2 is to create contracts between all the companies that you need or need you."
    else
      "Make money"
    end
  end

  def self.get_game
    game = Game.first
    unless game
      game = Game.create
      game.save
    end
    game
  end

 

  def calculate_static_costs
    companies = Company.all
    companies.each do |c|
      c.profit -=  c.fixedCost
      c.save
    end
  end

  def calculate_contract_profit
    companies = Company.all
    companies.each do |c|
      c.profit +=  c.contract_revenue - c.contract_fixed_cost - c.total_variable_cost
      c.save
    end
  end

  def calculate_sale_profit
    markets = Market.all
    total = self.total_customers
    current_progress = 0
    markets.each do |m|
      customers = m.complete_sales(current_progress, total, self)
      current_progress += customers.size
    end
  end

  def end_sub_round
    self.calculating = true
    self.save!
    Company.reset_profit
    self.calculate_static_costs
    self.calculate_contract_profit
    self.calculate_sale_profit
    Network.calculate_score
    Market.apply_effects
    self.sub_round += 1
    self.calculating = false
    self.save!
  end

  def total_customers
    total = 0
    markets = Market.all
    markets.each do |m|
      total += m.customer_amount
    end
    total
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

