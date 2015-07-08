# == Schema Information
#
# Table name: loans
#
#  id              :integer          not null, primary key
#  loan_amount     :decimal(, )
#  interest        :integer
#  duration        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  company_id      :integer
#  remaining       :integer
#  payment_failure :boolean          default(FALSE)
#  market_id       :integer
#

class Loan < ActiveRecord::Base
  attr_accessible :duration, :interest, :loan_amount

  belongs_to :company
  belongs_to :market

  parsed_fields :loan_amount

  def payments_simple
    total_sum = self.loan_amount * (self.interest.to_f / 100) + self.loan_amount
    payment = (total_sum / self.duration).to_i
    payment
  end

  def payments
    total_sum = self.loan_amount * (self.interest.to_f / 100) + self.loan_amount
    payment = (total_sum / self.duration).to_i
    payment_arr = []
    self.duration.times do
      payment_arr << payment
    end
    payment_arr
  end

  #TODO: Interest calculations
  def self.update_loans
    Loan.all.each do |l|
      payment = l.loan_amount / l.duration
      l.update_attribute(:remaining, l.duration) if l.remaining == nil
      if l.remaining > 0
        l.company.update_attribute(:capital, l.company.capital - payment)
        l.update_attribute(:remaining, l.remaining - 1)
      end
    end
  end

  def calculate_interest
    return 10
  end

  def get_payment
    self.loan_amount / self.duration
  end

end
