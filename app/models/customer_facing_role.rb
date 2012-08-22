
#Companies with the Customer Facing Role handle the actual sales with the customers
#They also decide the product sell price and target market for the network
class CustomerFacingRole < ActiveRecord::Base
  attr_accessible :service_level, :sell_price, :market_id, :product_type

  belongs_to :company
  belongs_to :market

  validates :service_level, presence:  true
  validates :sell_price, :numericality => { :greater_than => 0 }, :allow_nil => true

  #Returns the network that the company of this role belongs to
  def network
    self.company.network
  end

  #Checks if this role belongs to a company that is part of a network
  def network?
    self.belongs_to_network
  end

  #Parameters: Customers who selected this company, Total Satisfaction of all customers who chose this company
  #Registers the sales, updating all needed values for the network
  def register_sales(customers, total_sat)
    sales_made = customers.size
    self.network.satisfaction = 0
    network.sales = sales_made
    if sales_made > 0
       network.satisfaction = network.get_average_customer_satisfaction
    end
    #self.reputation += self.network.reputation_change
    self.network.save!
  end
  
end
# == Schema Information
#
# Table name: customer_facing_roles
#
#  id                 :integer         not null, primary key
#  sell_price         :integer
#  service_level      :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  company_id         :integer
#  market_id          :integer
#  reputation         :integer         default(100)
#  belongs_to_network :boolean         default(FALSE)
#  product_type       :integer
#

