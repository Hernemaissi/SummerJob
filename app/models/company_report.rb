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
# Table name: company_reports
#
#  id                   :integer          not null, primary key
#  year                 :integer
#  base_fixed_cost      :decimal(, )
#  customer_revenue     :decimal(, )
#  contract_revenue     :decimal(, )
#  profit               :decimal(, )
#  risk_control         :decimal(, )
#  contract_cost        :decimal(, )
#  variable_cost        :decimal(, )
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  company_id           :integer
#  launch_capacity_cost :decimal(, )      default(0.0)
#  extra_cost           :decimal(, )      default(0.0)
#  simulated_report     :boolean          default(TRUE)
#  launches             :integer
#  accident_cost        :decimal(20, 2)   default(0.0)
#  break_cost           :integer          default(0)
#  capacity_cost        :decimal(, )
#  unit_cost            :decimal(, )
#  experience_cost      :decimal(, )
#  marketing_cost       :decimal(, )
#  fixed_sat_cost       :decimal(, )
#  satisfaction         :decimal(, )
#  market_data          :text
#  loan_cost            :decimal(20, 2)   default(0.0)
#  expansion_cost       :decimal(20, 2)   default(0.0)
#  customer_amount      :integer
#

class CompanyReport < ActiveRecord::Base
  attr_accessible :base_fixed_cost, :contract_cost, :contract_revenue, :customer_revenue, :profit, :risk_control, :variable_cost, :year

  serialize :market_data, Hash

  belongs_to :company

  def total_fixed_cost
    self.marketing_cost + self.unit_cost + self.capacity_cost + self.experience_cost + self.extra_cost + self.break_cost + self.fixed_sat_cost
  end

  def total_variable_cost
    self.variable_cost * launches + self.contract_cost
  end

  def total_cost
    self.total_fixed_cost + self.total_variable_cost
  end

  def self.delete_simulated_reports
    CompanyReport.where("simulated_report = ?", true).each do |c|
      c.destroy
    end
  end

  def self.accept_simulated_reports
    CompanyReport.where("simulated_report = ?", true).each do |c|
      c.update_attribute(:simulated_report, false)
    end
  end

  def self.populate_launches
    CompanyReport.all.each do |c|
      c.update_attribute(:launches, 0);
    end
    true
  end

  

end
