class Game < ActiveRecord::Base
  attr_accessible :current_round, :max_rounds
  
  has_many :networks
  
  validates :current_round, presence: true
  validates :max_rounds, presence: true
  
  def get_round_objective
    if current_round == 1
      "The objective of round one is to have a business plan for your company that has been verified by the teacher"
    elsif current_round == 2
      "The objective of round two is to create contracts between all the companies that you need or need you"
    else
      "Make money"
    end
  end
  
end
# == Schema Information
#
# Table name: games
#
#  id            :integer         not null, primary key
#  current_round :integer         default(1)
#  max_rounds    :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

