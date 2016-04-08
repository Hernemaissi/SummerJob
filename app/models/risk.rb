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
# Table name: risks
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  description     :text
#  customer_return :integer
#  penalty         :integer
#  possibility     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  severity        :integer          default(1)
#

class Risk < ActiveRecord::Base

  attr_accessible :customer_return, :description, :penalty, :possibility, :title, :severity

  has_many :customer_facing_roles
  has_many :markets

  validates :title, presence: true
  validates :description, :presence => true
  validates :customer_return, :presence => true, :numericality => { :greater_than_or_equal_to  => 0 }
  validates :possibility,  :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :severity, :presence => true, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }

 
  def self.apply_risks
    companies = CustomerFacingRole.all
    companies.each do |c|
      c.risk = nil
      if c.market && c.sales_made > 0
        risk_mit = Network.get_risk_mitigation(c)
        happening = 0
        Risk.all.each do |r|
          chance = r.possibility - risk_mit
          chance = (chance > 0) ? chance : 1            #There is always at least 1% chance for a accident to happen, no matter how much risk control is used
          happening = Random.rand(1..100)
          if happening <= chance
            c.risk = r if (c.risk == nil || c.risk.severity < r.severity)
          end
        end
      end
      c.save!
      if c.risk && c.market && c.sales_made > 0
        Market.all.each do |m|
          m.customer_facing_roles.all.each do |cf|
            if cf.sales_made > 0
              distance = (c.market.id == m.id) ? c.company.distance(cf.company) : (c.company.distance(cf.company) - 1)
              lower = 0.1 * (c.risk.severity - distance)
              if (lower < 0)
                lower = 0
              end
              if (cf.id != c.id)
                lower = lower / 2
              end
              new_sales = cf.sales_made - cf.sales_made * lower
              cf.update_attribute(:sales_made, new_sales)
            end
          end
        end
      end
    end
  end


  def self.get_risk_news
    news = ""
    CustomerFacingRole.where("risk_id IS NOT NULL").all.each do |c|
      news << "<h2>#{c.risk.title}</h2>\n#{c.risk.description}\n".html_safe
      news << "An accident has happened in #{c.market.name} for the #{c.company.name}\n"
      news << "This caused lost sales for everyone in the market because of waning interest"
    end
    news
  end

  
end
