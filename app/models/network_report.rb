# == Schema Information
#
# Table name: network_reports
#
#  id                      :integer          not null, primary key
#  year                    :integer
#  sales                   :integer
#  max_launch              :integer
#  performed_launch        :integer
#  customer_revenue        :decimal(, )
#  satisfaction            :decimal(, )
#  network_id              :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  net_cost                :decimal(, )      default(0.0)
#  customer_facing_role_id :integer
#  relative_net_cost       :decimal(, )
#  simulated_report        :boolean          default(TRUE)
#  company_id              :integer
#  leader                  :string(255)
#  max_customers           :integer
#

class NetworkReport < ActiveRecord::Base
  attr_accessible :customer_revenue, :network_id, :promised_level, :realized_level, :sales, :satisfaction, :year

  belongs_to :network
  belongs_to :customer_facing_role
  has_and_belongs_to_many :companies

  def self.delete_simulated_reports
    NetworkReport.where("simulated_report = ?", true).each do |n|
      n.destroy
    end
  end

  def self.accept_simulated_reports
    NetworkReport.where("simulated_report = ?", true).each do |n|
      n.update_attribute(:simulated_report, false)
    end
  end

end


