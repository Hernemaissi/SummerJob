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
#

class CompanyReport < ActiveRecord::Base
  attr_accessible :base_fixed_cost, :contract_cost, :contract_revenue, :customer_revenue, :profit, :risk_control, :variable_cost, :year

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
