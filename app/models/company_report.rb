class CompanyReport < ActiveRecord::Base
  attr_accessible :base_fixed_cost, :contract_cost, :contract_revenue, :customer_revenue, :profit, :risk_control, :variable_cost, :year

  belongs_to :company

  def total_fixed_cost
    self.base_fixed_cost + self.contract_cost + self.risk_control
  end
end
# == Schema Information
#
# Table name: company_reports
#
#  id               :integer         not null, primary key
#  year             :integer
#  base_fixed_cost  :decimal(, )
#  customer_revenue :decimal(, )
#  contract_revenue :decimal(, )
#  profit           :decimal(, )
#  risk_control     :decimal(, )
#  contract_cost    :decimal(, )
#  variable_cost    :decimal(, )
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  company_id       :integer
#

