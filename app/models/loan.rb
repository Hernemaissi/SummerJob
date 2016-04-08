=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

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

  validates :loan_amount, :numericality => true

  def self.take_loan(company, amount, duration, interest = nil)
    interest = Loan.calculate_interest(company) if interest == nil
    loan = company.loans.create(:duration => duration, :loan_amount => amount, :interest => interest)
    loan.update_attribute(:remaining, duration) if loan.valid?
    company.update_attribute(:capital, company.capital + loan.loan_amount.to_i) if loan.valid?
    return loan
  end

  def payments
    total_sum = self.loan_amount
    payment = (total_sum / self.duration).to_i
    payment_arr = []
    remaining = total_sum
    i = 1
    actual_interest = self.interest / 100.0
    self.duration.times do
      interest = (payment * (1+actual_interest)**i) - payment
      payment_arr << (payment + interest).round
      remaining = remaining - payment
      i += 1
    end
    payment_arr
  end


  def self.update_loans
    Loan.all.each do |l|
      l.update_attribute(:remaining, l.duration) if l.remaining == nil
      if l.remaining > 0
        l.update_attribute(:remaining, l.remaining - 1)
      end
    end
  end

  def self.calculate_interest(company)
    if company.capital >= 0
      return company.role.market.interest
    else
      return company.role.market.interest * 2
    end
  end


  def get_payment
    i = self.duration - self.remaining
    payment = self.payments[i]
    payment = 0 if payment.nil?
    return payment
  end

end
