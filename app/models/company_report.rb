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
#

class CompanyReport < ActiveRecord::Base
  attr_accessible :base_fixed_cost, :contract_cost, :contract_revenue, :customer_revenue, :profit, :risk_control, :variable_cost, :year

  belongs_to :company

  def total_fixed_cost
    self.risk_control + self.launch_capacity_cost + self.extra_cost
  end

  def total_variable_cost
    self.variable_cost + self.contract_cost
  end

  def self.delete_simulated_reports
    CompanyReport.where("simulated_report = ?", true).each do |c|
      c.destroy
    end
  end

  

end
