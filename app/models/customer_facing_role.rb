class CustomerFacingRole < ActiveRecord::Base
  attr_accessible :promised_service_level, :sell_price, :market_id

  belongs_to :company
  belongs_to :market

  validates :promised_service_level, presence:  true
  validates :sell_price, :numericality => { :greater_than => 0 }, :allow_nil => true

  def network
    self.company.network
  end

  def network?
    self.belongs_to_network
  end

  def register_sales(customers)
    average_satisfaction = 0
    self.company.revenue = 0
    sales_made = 0
    self.network.satisfaction = 0
    customers.each do |c|
      if c.chosen_company == self
        self.company.revenue += sell_price
        average_satisfaction += c.satisfaction
        sales_made += 1
      end
    end
    network.sales = sales_made
    if sales_made > 0
       average_satisfaction = ((average_satisfaction / sales_made) * 100).round * 0.01
       self.network.satisfaction = average_satisfaction
    end
    #self.reputation += self.network.reputation_change
    self.save!
    self.network.save!
    self.company.save!
  end
  
end
# == Schema Information
#
# Table name: customer_facing_roles
#
#  id                     :integer         not null, primary key
#  sell_price             :integer
#  promised_service_level :integer
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  company_id             :integer
#  market_id              :integer
#  reputation             :integer         default(100)
#  belongs_to_network     :boolean         default(FALSE)
#

