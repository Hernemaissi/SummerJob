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
#

