# == Schema Information
#
# Table name: loans
#
#  id          :integer          not null, primary key
#  loan_amount :decimal(, )
#  interest    :integer
#  duration    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :integer
#  remaining   :integer
#

class Loan < ActiveRecord::Base
  attr_accessible :duration, :interest, :loan_amount

  belongs_to :company

  parsed_fields :loan_amount


  def calculate_interest
    if duration == 1
      return 5
    elsif duration == 2
      return 10
    else
      return 15
    end
  end

  def payments
    total_sum = self.loan_amount * (self.interest.to_f / 100) + self.loan_amount
    payment = (total_sum / self.duration).to_i
  end


end
