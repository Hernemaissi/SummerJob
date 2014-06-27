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

  def self.update_loans
    Loan.all.each do |l|
      if l.remaining > 0
        capital = l.company.capital
        if (capital >= l.payments[l.duration - l.remaining])
          l.company.update_attribute(:capital, l.company.capital - l.payments[l.duration - l.remaining])
          l.update_attribute(:remaining, l.remaining - 1)
        else
          l.update_attribute(:payment_failure, true)
        end
        
      end
    end
  end


end
