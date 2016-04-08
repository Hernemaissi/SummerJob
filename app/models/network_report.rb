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


