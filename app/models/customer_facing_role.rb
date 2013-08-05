# == Schema Information
#
# Table name: customer_facing_roles
#
#  id                 :integer          not null, primary key
#  sell_price         :integer
#  service_level      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :integer
#  market_id          :integer
#  reputation         :integer          default(100)
#  belongs_to_network :boolean          default(FALSE)
#  product_type       :integer
#  sales_made         :integer          default(0)
#  last_satisfaction  :decimal(, )
#  risk_id            :integer
#


#Companies with the Customer Facing Role handle the actual sales with the customers
#They also decide the product sell price and target market for the network
class CustomerFacingRole < ActiveRecord::Base
  has_paper_trail
  attr_accessible :service_level, :sell_price, :market_id, :product_type

  belongs_to :company
  belongs_to :market
  belongs_to :risk

  validates :service_level, presence:  true
  validates :sell_price, :numericality => { :greater_than => 0, :less_than_or_equal_to => 50000000 }, :allow_nil => true

  #Returns the network that the company of this role belongs to
  def network
    self.company.network
  end

  #Checks if this role belongs to a company that is part of a network
  def network?
    self.belongs_to_network
  end


  def register_sales(sales_made)
    self.sales_made = sales_made
    self.save!
  end

  #Returns the amount of launches based on amount of sells made
  # and approximate utilization
  def get_launches
    if self.product_type == 1
      max_capacity = self.company.network_launches
      max_customers = max_capacity * Company.get_capacity_of_launch(self.product_type, self.service_level)
      if max_customers == 0
        return 0
      end
      puts "Sales: #{self.sales_made}"
      puts "Max customers: #{max_customers}"
      perc = ((self.sales_made.to_f / max_customers.to_f) * 100).to_i
      if perc >= 80         #If capacity utilization is at least 80%, are launches are made
        return max_capacity
      elsif perc >= 60    # If utilization is between 60 and 80%, then 90% of launches are made
        return (max_capacity * 0.9).ceil
      elsif perc >= 40    # If utilization is between 40% and 60%, then 70% of the launches are made
        return (max_capacity * 0.7).ceil
      elsif perc >= 20    # If utilization is between 20% and 40%, then 50% of the launches are made
        return (max_capacity * 0.5).ceil
      else                      # If utilization is under 20%, return the lowest amount of launches needed to fly all customers
        if self.sales_made % Company.get_capacity_of_launch(self.product_type, self.service_level) == 0
          return self.sales_made / Company.get_capacity_of_launch(self.product_type, self.service_level)
        else
          return self.sales_made / Company.get_capacity_of_launch(self.product_type, self.service_level) + 1
        end
      end
    else

      return (self.sales_made.to_f / Company.get_capacity_of_launch(self.product_type, self.service_level)).ceil
    end
  end

  def self.apply_risk_penalties
    CustomerFacingRole.where("risk_id IS NOT NULL").all.each do |c|
      launch_revenue = c.sell_price * Company.get_capacity_of_launch(c.product_type, c.service_level)
      penalty = launch_revenue * (c.risk.customer_return.to_f / 100)
      companies = Network.get_network(c)
      share = (penalty / companies.size).to_i
      companies.each do |com|
        com.revenue -= share
        com.profit -= share
        com.total_profit -= share
        com.save!
      end
    end
  end

  
  def generate_report
    n = NetworkReport.new
    n.sales = self.sales_made
    n.max_launch = self.company.network_launches
    n.performed_launch = self.company.launches_made
    n.customer_revenue = self.company.revenue
    n.year = Game.get_game.sub_round
    n.satisfaction = self.last_satisfaction
    n.net_cost = self.network_net_cost
    n.save!
    self.network_report = n
    self.save!
  end

  def self.generate_reports
    CustomerFacingRole.all.each do |c|
      c.generate_report
    end
  end

  def network_net_cost
    net_cost = 0
    companies = Network.get_network(self)
    companies.each do |c|
      net_cost += c.net_cost
    end
    net_cost
  end

end
