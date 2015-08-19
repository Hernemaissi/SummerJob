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
#  experience        :decimal(, )
#  marketing         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  update_flag       :boolean
#

class Role < ActiveRecord::Base
  has_paper_trail :only => [:update_flag]
  attr_accessible :company_id, :experience, :last_satisfaction, :market_id, :marketing, :number_of_units,
    :product_type, :sales_made, :sell_price, :service_level, :unit_size

  belongs_to :company
  belongs_to :market

  validate :market_change
  

  def get_launches(launches = 0)

    max_capacity = (launches == 0) ? self.company.network_launches : launches
    max_customers = max_capacity * self.company.network_capacity
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

  def generate_report
    if self.company.network_ready?
      n = NetworkReport.new
      n.sales = self.sales_made
      n.max_launch = self.company.network_launches
      n.performed_launch = self.company.launches_made
      n.customer_revenue = self.company.revenue
      n.year = Game.get_game.sub_round
      n.satisfaction = self.last_satisfaction
      n.net_cost = self.network_net_cost
      n.leader = self.company.name
      n.max_customers = self.company.launches_made * self.company.network_capacity
      n.save!
      companies = self.company.get_network
      companies.each do |c|
        c.network_reports << n
        c.save!
      end
    else
      n = NetworkReport.new
      n.year = Game.get_game.sub_round
      n.save!
      self.company.network_reports << n
      self.save!
    end
  end

  def self.generate_reports
    customer_facing = Role.all
    customer_facing.reject! { |c| !c.company.is_customer_facing? }
    customer_facing.each do |c|
      c.generate_report
    end
  end

  def bonus_satisfaction
    companies = self.company.get_network
    return 0 if companies.empty?
    bonus = 0.0
    companies.each do |c|
      if c.business_plan.grade != nil
        bonus += Game.get_game.bonus_hash[c.business_plan.grade.to_s].to_f
      end
    end
    sat = bonus / companies.size
    sat
  end

  #Calculates the total cost of the network, for money flowing out (money transferred in contracts is not considered)
  def network_net_cost
    net_cost = 0
    companies = Network.get_network(self)
    companies.each do |c|
      net_cost += c.net_cost
    end
    net_cost
  end

  def parameter_value(parameter)
    parameter = parameter.downcase
    if parameter == "c"
      return unit_size
    end
    if parameter == "u"
      return number_of_units
    end
    if parameter == "e"
      return experience
    end
    if parameter == "m"
      return marketing
    end
  end


  private

  def market_change
    if self.market_id_changed? && !(self.market_id_was == nil) && !self.company.is_customer_facing?
      errors.add(:market_id, "You cannot change your primary market")
    end
  end


end
