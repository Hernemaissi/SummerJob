# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  sell_price        :integer
#  service_level     :integer
#  product_type      :integer
#  market_id         :integer
#  company_id        :integer
#  sales_made        :integer          default(0)
#  last_satisfaction :decimal(, )
#  number_of_units   :integer
#  unit_size         :integer
#  experience        :integer
#  marketing         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Role < ActiveRecord::Base
  attr_accessible :company_id, :experience, :last_satisfaction, :market_id, :marketing, :number_of_units,
    :product_type, :sales_made, :sell_price, :service_level, :unit_size

  belongs_to :company
  belongs_to :market

  def get_launches(launches = 0)

    max_capacity = (launches == 0) ? self.company.network_launches : launches
    max_customers = max_capacity * self.network_capacity
    if max_customers == 0
      return 0
    end
    puts "Sales: #{self.sales_made}"
    puts "Max customers: #{max_customers}"
    perc = ((self.sales_made.to_f / max_customers.to_f) * 100).to_i
    
    if perc >= 80         #If capacity utilization is at least 80%, are launches are made
      return max_capacity
    elsif perc >= 70    #If capacity utilization is between 70% and 80%, then 95% of launches are made
      return (max_capacity * 0.95).ceil
    elsif perc >= 60    # If utilization is between 60 and 70%, then 90% of launches are made
      return (max_capacity * 0.9).ceil
    elsif perc >= 50    # If utilization is between 50 and 60%, then 80% of launches are made
      return (max_capacity * 0.8).ceil
    elsif perc >= 40    # If utilization is between 40% and 50%, then 70% of the launches are made
      return (max_capacity * 0.7).ceil
    elsif perc >= 30 # If utilization is between 30% and 40%, then 60% of the launches are made
      return (max_capacity * 0.6).ceil
    else    # If utilization is under 40%, then 50% of the launches are made, except no empty launches are made
      uti_launches = (max_capacity * 0.5).ceil
      return [uti_launches, self.sales_made].min
    end

  end


end
