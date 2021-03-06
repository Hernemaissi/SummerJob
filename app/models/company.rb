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
# Table name: companies
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  fixed_cost         :decimal(20, 2)   default(0.0)
#  variable_cost      :decimal(20, 2)   default(0.0)
#  revenue            :decimal(20, 2)   default(0.0)
#  profit             :decimal(20, 2)   default(0.0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  group_id           :integer
#  about_us           :text
#  assets             :decimal(20, 2)   default(0.0)
#  network_id         :integer
#  belongs_to_network :boolean          default(FALSE)
#  service_type       :string(255)
#  initialised        :boolean          default(FALSE)
#  for_investors      :text
#  risk_control_cost  :decimal(20, 2)   default(0.0)
#  risk_mitigation    :integer          default(0)
#  max_capacity       :integer          default(0)
#  capacity_cost      :decimal(20, 2)   default(0.0)
#  values_decided     :boolean          default(FALSE)
#  extra_costs        :decimal(20, 2)   default(0.0)
#  total_profit       :decimal(20, 2)   default(0.0)
#  launches_made      :integer          default(0)
#  update_flag        :boolean          default(FALSE)
#  accident_cost      :decimal(20, 2)   default(0.0)
#  earlier_choice     :string(255)
#  logo               :string(255)
#  image              :string(255)
#  show_read_events   :boolean          default(TRUE)
#  break_cost         :integer          default(0)
#  company_type_id    :integer
#  capital            :decimal(, )      default(0.0)
#  fixed_sat_cost     :decimal(, )
#  negative_capital   :boolean          default(FALSE)
#  expanded_markets   :text
#  ebt                :decimal(20, 2)   default(0.0)
#  market_data        :text
#  test               :boolean          default(FALSE)
#

class Company < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  has_paper_trail :only => [:update_flag]

  serialize :expanded_markets, Hash
  serialize :market_data, Hash

  
  after_create :init_business_plan
  
  attr_accessible :name, :group_id, :service_type, :risk_control_cost, :risk_mitigation, :capacity_cost, :variable_cost,  :about_us, :operator_role_attributes, 
  :customer_facing_role_attributes, :service_role_attributes, :max_capacity, :extra_costs, :accident_cost, :earlier_choice, :image, :break_cost, :role_attributes,
  :fixed_sat_cost

  mount_uploader :image, ImageUploader
  belongs_to :group
  belongs_to :network
  belongs_to :company_type
  has_one :business_plan, :dependent => :destroy
  has_many :revisions, :dependent => :destroy
  has_many :company_reports, :dependent => :destroy
  has_one :operator_role, :dependent => :destroy
  has_one :customer_facing_role, :dependent => :destroy
  has_one :service_role, :dependent => :destroy
  has_one :role, :dependent => :destroy
  has_and_belongs_to_many :network_reports
  accepts_nested_attributes_for :operator_role, :customer_facing_role, :service_role, :role
  
  has_many :sent_rfps, foreign_key: "sender_id",
                           class_name: "Rfp",
                           :dependent => :destroy
  has_many :received_rfps, foreign_key: "receiver_id",
                           class_name: "Rfp",
                           :dependent => :destroy
                          
  has_many :contracts_as_supplier, foreign_key: "service_provider_id",
                                   class_name: "Contract",
                                   :dependent => :destroy
  
  has_many :contracts_as_buyer, foreign_key: "service_buyer_id",
                                class_name: "Contract",
                                :dependent => :destroy

  

  has_many :events, :dependent => :destroy

  has_many :loans, :dependent => :destroy

   has_many :processes_as_first_party, foreign_key: "first_party_id",
                                   class_name: "ContractProcess",
                                   :dependent => :destroy

  has_many :processes_as_second_party, foreign_key: "second_party_id",
                                class_name: "ContractProcess",
                                :dependent => :destroy
                  



  #validate :capital_validation , :if => :capital_validation?


  validates :name, presence: true,:length=> 5..20
  validates :group_id, presence: true
  validates :fixed_cost, presence: true
  validates :variable_cost, presence: true
  validates :revenue, presence: true
  validates :profit, presence: true

  
  def set_role(test = false)
    self.create_role
    self.role.marketing = 0 if self.company_type.marketing_produce?
    self.role.unit_size = 0 if self.company_type.capacity_produce?
    self.role.number_of_units = 0 if self.company_type.unit_produce?
    self.role.experience = 0 if self.company_type.experience_produce?
    self.role.service_level = 1
    self.role.product_type = 1
    self.role.test = test
    self.role.save
  end
  

  

  #Destroys the role of the company, depending on type
  def destroy_role
    if self.role
      Role.destroy(self.role.id)
    end
  end

  def contract_processes
    self.processes_as_first_party.all.concat(self.processes_as_second_party.all)
  end

  #Returns true if the company is customer facing company
  def is_customer_facing?
    self.company_type.price_set?
  end

  #Returns true if the company is an operator
  def is_operator?
    self.service_type == "Operator"
  end

  #Returns true if the company is a service type
  def is_service?
    !self.is_operator? && !self.is_customer_facing?
  end

  #Returns true if the company is a Technology company
  def is_tech?
    self.service_type == "Technology"
  end

  #Returns true if the company is a supplier company
  def is_supply?
    self.service_type == "Supplier"
  end

  #Returns the different company types as an array
  def self.types
    ['Customer', 'Operator', 'Technology', 'Supplier']
  end

  def self.segments
    {"1,1" => "Budget Space Hop", "3,1" => "Luxury Space Hop", "1,3" => "Budget Space Cruise", "3,3" => "Luxury Space Cruise"}
  end
  
  def self.search_fields
      ['Name', 'Student Number', "Department"]
  end

  def self.rfp_targets
    Hash["Operator", "Marketing, Technology, Supply", "Customer", "Operator", "Technology", "Operator", "Supplier", "Operator"]
  end

  def suppliers
    suppliers = []
    self.contracts_as_buyer.includes(:service_provider).each do |c|
      suppliers << c.service_provider unless c.void?
    end
    return suppliers
  end

  def suppliers_from_year(year)
    suppliers = []
    self.contracts_as_buyer.all.each do |c|
      suppliers << c.service_provider if c.stamps.include?(year)
    end
    return suppliers
  end

  def buyers
    buyers = []
    self.contracts_as_supplier.all.each do |c|
      buyers << c.service_buyer unless c.void
    end
    return buyers
  end

  def buyers_from_year(year)
    buyers = []
    self.contracts_as_supplier.all.each do |c|
      buyers << c.service_buyer if c.stamps.include?(year)
    end
    return buyers
  end

  #Sends an RFP to another company
  def send_rfp!(other_company, content)
    sent_rfps.create!(receiver_id: other_company.id, content: content)
  end

  #Returns true if the company has already sent an rfp to the company given as a parameter
  def has_sent_rfp?(other_company)
    sent_rfps.find_by_receiver_id(other_company.id)
  end
  
  #Returns true if the company has a contract with the company given as a parameter and is a provider in that contract
  def provides_to?(other_company)
    contracts = contracts_as_supplier.where(:service_buyer_id => other_company.id)
    contracts.all.each do |c|
      return c unless c.void?
    end
    return nil
  end

  #Returns true if the company has made a contract with the company given as parameter
  def has_contract_with?(other_company)
    if !provides_to?(other_company)
      other_company.provides_to?(self)
    else
      true
    end
  end
  #WUT, fix maybe, now identical with ^
  def get_contract_with(other_company)
    if !provides_to?(other_company)
      other_company.provides_to?(self)
    else
      provides_to?(other_company)
    end
  end

  #????
  def self.search(field, query)
    name = 0
    student_number = 1
    department = 2
    if field == Company.search_fields[name]
      return Company.where('name LIKE ?', "%#{query}%")
    elsif field == Company.search_fields[student_number]
      return Company.where('student_number LIKE ?', "%#{query}%")
    elsif field == Company.search_fields[department]
      return Company.where('department LIKE ?',  "%#{query}%")
    else
      return []
    end
  end

  #Returns true if company has made a contract with where the other party has a certain service type
  def has_contract_with_type?(company_type)
    companies = Company.where("company_type_id = ?", company_type.id)
    companies.each do |c|
      if has_contract_with?(c)
        return true
      end
    end
    return false
  end

  #New algorithm for checking if company is part of a network, has to be dynamic now that networks change
  def part_of_network()
    needs = self.company_type.needs
    partner_produces = []
    partner_produces.concat(self.company_type.produces)
    self.suppliers.each do |s|
      partner_produces.concat(s.company_type.produces)
    end
    return false unless (needs & partner_produces) == needs

    produces = self.company_type.produces
    produces.reject! { |x| !CompanyType.anyone_needs?(x)}
    partner_needs = []
    partner_needs.concat(self.company_type.needs)
    self.buyers.each do |b|
      partner_needs.concat(b.company_type.needs)
    end
    return false unless (produces & partner_needs) == produces

    return true
  end

  def part_of_a_ready_network?
    cs = self.get_network.reject { |c| !c.is_customer_facing?}
    cs.each do |c|
      return true if c.network_ready?
    end
    return false
  end

  

  #Returns a customer facing company of the network or nil if it doesn't have one
  def get_customer_facing_company
    companies = self.get_network
    companies.reject! { |c| !c.is_customer_facing? }
    companies
  end

  
  

  #Returns all customer_facing_companies associated with the network, not just the direct ones
  def get_roots
    roots = self.get_customer_facing_company
    results = []
    i = 0
    while !roots.empty? do
      r = roots.first
      results << r
      companies = Network.get_network(r.role)
      companies.each do |c|
        puts "I is: #{i}"
        roots.concat(c.get_customer_facing_company).uniq
        puts "We here?"
        i = i+1
      end
      i = 0
      roots.delete_if { |x| results.include?(x) }
      roots = roots.uniq
      roots.delete(r)
      puts "Root size #{roots.length}"
    end
    return results
  end

  def complete_network(root_list)
    all_companies = []
    root_list.each do |r|
      all_companies.concat(Network.get_network(r.role))
    end
    return all_companies.uniq
  end


  #Gets launches from all the companies 
  def network_launches
    if self.company_type.unit_produce?
      return self.role.number_of_units
    end
    if self.suppliers.empty?
      return 0
    end
    launches = 0
    unless self.suppliers.first.company_type.unit_produce?
      self.suppliers.each do |s|
        launches += s.network_launches
      end
    else
      self.suppliers.each do |s|
        launches += s.provide_parameter("u")[self.id]
      end
    end
    
    return launches
  end

  def network_max_customers
    if self.role.max_customers?
      return self.role.max_customers
    else
      return self.calculate_max_customers
    end
  end

  def average_network_capacity
    total = 0
    amount = 0
    net = Company.local_network(self)
    net.each do |c|
      if c.company_type.capacity_produce
        c.contracts_as_supplier.reject{|x| x.void? }.each do |s|
          if s.bid.capacity_amount <= c.role.unit_size
            total += s.bid.capacity_amount
            amount += 1
          else
            total += c.role.unit_size
            amount += 1
          end
        end
      end
    end
    return 0 if amount == 0
    avg = total.to_f / amount.to_f
    return avg.round
  end

  def calculate_max_customers
    max_launches = self.network_launches
    self.distribute_launches(max_launches)
    net = Company.local_network(self).reject { |c| !c.company_type.capacity_produce? }
    local = Company.local_network(self)
    customers = 0
    net.each do |c|
      c.contracts_as_supplier.reject{|x| x.void? }.each do |s|
        if s.bid.capacity_amount <= c.role.unit_size
          customers += s.launches_made * s.bid.capacity_amount
        else
          customers += s.launches_made * c.role.unit_size
        end
      end
    end
    local.each do |c|
      c.launches_made = 0
      c.market_data = {}
      c.save(validate: false)
      c.contracts_as_buyer.each do |con|
        con.update_attribute(:launches_made, 0)
      end
    end
    self.role.update_attribute(:max_customers, customers)
    return customers
  end

  def self.reset_max_customers
    Role.all.each do |r|
      r.update_attribute(:max_customers, nil)
    end
  end

  def network_capacity
    return self.local_network_parameter("c")
  end

  def self.save_launches
    customer_facing = Company.all.reject { |c| (!c.is_customer_facing? || c.test) }
    customer_facing.each do |c|
      launches = c.role.get_launches
      c.distribute_launches(launches)
    end
  end

=begin
  def distribute_launches(launches)
    if !self.is_customer_facing? || self.network_ready?
      self.update_attribute(:launches_made, self.launches_made + launches) if self.enough_money?
      sups = self.suppliers
      sups.each do |s|
        self.contracts_as_buyer.where("service_provider_id = ?", s.id).all.each do |c|
          c.update_attribute(:launches_made, launches) unless c.void? || !s.enough_money?
        end
        s.distribute_launches(launches)

      end
      puts "#{self.name} : #{self.launches_made}"
    end
  end
=end

  def distribute_launches(launches)
    if !self.is_customer_facing? || self.network_ready?
      self.update_attribute(:launches_made, self.launches_made + launches) if self.enough_money?
      if self.is_customer_facing?
        market_data = self.market_data
        market_data[self.role.market.name] = {} if !self.market_data[self.role.market.name]
        market_data[self.role.market.name]["launches"] = launches
        self.update_attribute(:market_data, market_data)
      end
      sups = self.suppliers.sort_by {|c| c.company_type}.chunk { |c| c.company_type}
      sups.each do |type, array|
        unless array.empty?
          if array.first.company_type.unit_produce
            evens = Company.even_unit_launches(launches, array, self.id)
          else
            evens = Company.even_launches(launches, array.size)
          end
        end
        
        array.each_with_index do |s, i|
          self.contracts_as_buyer.where("service_provider_id = ?", s.id).all.each do |c|
            c.update_attribute(:launches_made, evens[i]) unless c.void? || !s.enough_money?
            unless c.void?
              market = self.role.market.name
              s.market_data[market] = {} if !s.market_data[market]
              s.market_data[market]["launches"] = (s.market_data[market]["launches"].nil?) ? evens[i] : s.market_data[market]["launches"] + evens[i]
            end
          end
          s.distribute_launches(evens[i])
        end
      end
    end
  end

  def self.even_launches(launches, size)
    evens = []
    split = launches / size
    size.times do |i|
      evens << split
    end
    remainder = launches % size
    i = 0
    while remainder > 0
      evens[i] += 1
      remainder -= 1
      i = (i < evens.size - 1) ? i+1 : 0
    end
    return evens
  end

  def self.even_unit_launches(launches, array, buyer_id)
    size = array.size
    evens = []
    full = []
    split = launches / size
    size.times do |i|
      evens << split
    end
    remainder = launches % size
    array.each_with_index do |c,i|
      parameter_provided = c.provide_parameter("u")[buyer_id]
      if parameter_provided < evens[i]
        remainder += evens[i] - parameter_provided
        evens[i] = parameter_provided
        full << i
      end
    end
    i = 0
    while remainder > 0 && full.size < array.size
   
      unless full.include?(i)
        evens[i] += 1
        remainder -= 1
        full << i if evens[i] == array[i].provide_parameter("u")[buyer_id] && !full.include?(i)
      end
      i = (i < evens.size - 1) ? i+1 : 0
    end

    return evens

  end

  def launch_test(launches)
    self.distribute_launches(launches)
    net = Company.local_network(self)
    array = []
    net.each do |c|
      array << "#{c.name} : #{c.launches_made}"
    end
    Company.reset_launches_made
    array.each do |a|
      puts a
    end
    return nil
  end




  def self.reset_launches_made
    Company.all.each do |c|
      c.launches_made = 0
      c.market_data = {}
      c.save(validate: false)
      c.contracts_as_buyer.each do |con|
        con.update_attribute(:launches_made, 0)
      end
    end
  end

  

  

  #Creates a revision of the company's current business plan
  def make_revision()
    rev = self.revisions.create()
    rev.value_proposition = self.business_plan.plan_parts.find_by_title("Value Proposition").content
    rev.revenue_streams =  self.business_plan.plan_parts.find_by_title("Revenue Streams").content
    rev.cost_structure =  self.business_plan.plan_parts.find_by_title("Cost Structure").content
    rev.key_resources =  self.business_plan.plan_parts.find_by_title("Key Resources").content
    rev.key_activities =  self.business_plan.plan_parts.find_by_title("Key Activities").content
    rev.customer_segments =  self.business_plan.plan_parts.find_by_title("Customer Segments").content
    rev.key_partners =  self.business_plan.plan_parts.find_by_title("Key Partners").content
    rev.channels =  self.business_plan.plan_parts.find_by_title("Channels").content
    rev.customer_relationships = self.business_plan.plan_parts.find_by_title("Customer Relationships").content
    rev.reasoning = self.business_plan.plan_parts.find_by_title("Reasoning").content
    rev.save!
  end

  #Returns true if the company's business plan has been submitted
  def round_1_completed?
    business_plan.verified?
  end

  #Returns true if the company belongs to a network (service, operator) or if the company belongs to a network and has
  #decided on the sell price (customer facing)
  def round_2_completed?
    if self.is_customer_facing?
      return self.part_of_network && self.role.sell_price

    else
      return self.part_of_network
    end
  end

  def marketing_cost(market=nil)
    return 0 if !self.role.marketing || self.role.marketing == 0
    market = self.role.market if market == nil
    market = Market.first if market == nil
    return self.role.marketing
  end

  def capacity_cost(market=nil)
    return 0 if !self.role.unit_size || self.role.unit_size == 0
    market = self.role.market if market == nil
    market = Market.first if market == nil
    capa1 = market.variables["capa1"].to_i
    capa2 = market.variables["capa2"].to_i
    return (capa1*2**self.role.unit_size + capa2).round
  end

  def unit_cost(market=nil)
    return 0 if !self.role.number_of_units || self.role.number_of_units == 0
    market = self.role.market if market == nil
    market = Market.first if market == nil
    unit1 = market.variables["unit1"].to_i
    unit2 = market.variables["unit2"].to_i
    return (unit1 * self.role.number_of_units + unit2).round
  end

  def experience_cost(market=nil)
    return 0 if !self.role.experience || self.role.experience == 0
    market = self.role.market if market == nil
    market = Market.first if market == nil
    exp2 = market.variables["exp2"].to_i
    cost = [0, (Math.tan((self.role.experience/100.0-0.5)*Math::PI)+10)*exp2/10].max
    return cost.round
  end

  def reverse_experience_cost(cost, market=nil)
    market = self.role.market if market == nil
    market = Market.first if market == nil
    exp2 = market.variables["exp2"].to_i
    return ((Math.atan(10*cost.to_f/exp2-10)/Math::PI+0.5)*100)
  end

  def preview_costs(type)
    markets = {}
    Market.all.each do |m|
      case type
      when 0
        markets[m.name] = self.marketing_cost(m)
      when 1
        markets[m.name] = self.unit_cost(m)
      when 2
        markets[m.name] = self.capacity_cost(m)
      when 3
        markets[m.name] = self.experience_cost(m)
      end
      
    end
    return markets
  end


  #Returns a hash containing company fixed and variable cost depending on company choices
  def get_stat_hash(level, type, risk_mit, variable_cost, sell_price, market_id, marketing, capacity, unit, experience, fixed_sat)
    stat_hash = {}
    self.role.service_level = level
    self.role.product_type = type
    self.role.marketing = marketing
    self.role.unit_size = capacity
    self.role.number_of_units = unit
    self.role.experience = experience
    self.fixed_sat_cost = fixed_sat

    stat_hash["marketing_cost"] = self.marketing_cost
    stat_hash["capacity_cost"] = self.capacity_cost
    stat_hash["unit_cost"] = self.unit_cost
    stat_hash["experience_cost"] = self.experience_cost
    stat_hash["fixed_sat"] = self.fixed_sat_cost
    stat_hash["variable_cost"] = variable_cost
    stat_hash["service_level"] = level
    stat_hash["product_type"] = type
    
    stat_hash["variable_limit"] = self.company_type.limit_hash["max_variable_sat"]
    stat_hash["variable_min"] = self.company_type.limit_hash["min_variable_sat"]
    stat_hash["sell_price"] = sell_price
    
    self.risk_mitigation = risk_mit
    puts "Risk mit is: #{risk_mit}"
    #self.calculate_mitigation_cost
    stat_hash["risk_cost"] = 0 #self.risk_control_cost
    puts "stat_hash risk_cost is: #{stat_hash["risk_cost"]}"
    self.variable_cost = variable_cost
    if self.is_customer_facing?
      self.role.market_id = market_id
    end
    stat_hash["change_penalty"] = calculate_change_penalty
    
    stat_hash["break_cost"] = self.break_cost
    stat_hash["total_fixed"] = self.total_fixed_cost
    stat_hash
  end

  #Returns the cost from the contracts the company has as a buyer
  def contract_variable_cost
    contract_variable_cost = 0
    contracts_as_buyer.each do |c|
      contract_variable_cost += c.amount
    end
    contract_variable_cost
  end

  #Returns total fixed cost of the company by adding cost from the companies and the base fixed cost
  def total_fixed_cost
    return 0 if !fixed_sat_cost
    self.fixed_sat_cost + self.marketing_cost  + self.capacity_cost + self.unit_cost + self.experience_cost + self.extra_costs + self.break_cost + self.loan_payments
  end

  def fixed_sat_cost
    sat_cost = self.read_attribute(:fixed_sat_cost).to_f
    sat_cost = sat_cost / 100.0
    return (parameter_cost * sat_cost).to_i
  end

  def parameter_cost
    self.marketing_cost + self.unit_cost + self.experience_cost + self.capacity_cost
  end

  #Returns revenue generated from the contracts as provider
  def contract_revenue
    contract_revenue = 0
    contracts_as_supplier.each do |c|
      contract_revenue += c.amount
    end
    contract_revenue
  end

  def payment_from_contracts
    contract_revenue = 0
    contracts_as_supplier.each do |c|
      contract_revenue += c.amount * c.launches_made unless c.void?
    end
    return contract_revenue
  end

  def payment_to_contracts
    contract_cost = 0
    contracts_as_buyer.each do |c|
      contract_cost += c.amount * c.launches_made unless c.void?
    end
    return contract_cost
  end

  #Returns total revenue of the company
  def total_revenue
    revenue + contract_revenue
  end

  #Returns the total variable cost of the company that is formed by own selected variable cost, and cost from contracts
  def total_variable_cost
      return self.variable_cost * self.launches_made + self.payment_to_contracts
  end

  #Returns the total cost of the company except for the money transfers between companies
  def net_cost
    total_fixed_cost  + self.variable_cost * self.launches_made
  end

  #Creates a yearly report for the company
  #Takes a extra cost as a parameter because at this point it has already been reset
  def create_report
    report = self.company_reports.create
    report.year = Game.get_game.sub_round
    report.profit = self.profit
    report.customer_revenue = self.revenue
    report.contract_revenue = self.contract_revenue
    report.contract_cost = self.payment_to_contracts
    report.variable_cost = self.variable_cost
    report.extra_cost = self.extra_costs
    report.launches = self.launches_made
    report.break_cost = self.break_cost
    report.capacity_cost = self.capacity_cost
    report.marketing_cost = self.marketing_cost
    report.experience_cost = self.experience_cost
    report.unit_cost = self.unit_cost
    report.fixed_sat_cost = self.fixed_sat_cost
    report.loan_cost = self.loan_payments
    report.expansion_cost = self.calculate_change_penalty
    market = nil
    market = self.role.market
    report.satisfaction = self.get_satisfaction(market) unless market.nil?
    report.market_data = self.market_data
    if self.is_customer_facing?
      report.customer_amount = self.role.sales_made
    end

    if self.company_type.experience_produce? && self.get_customer_facing_company.first && market
      report.satisfaction = self.get_experience_satisfaction(market)
    end

    report.satisfaction = nil if market.nil?
    report.save!
  end

  def get_experience_satisfaction(market)
        exp1 = market.variables["exp1"].to_f
        exp = self.role.experience / 100 * exp1
        price = self.get_customer_facing_company.first.role.sell_price.to_f
        sat = self.get_satisfaction(market)
        v_sat = sat*([0.3, ([exp/price, 1].min)].max**2)
        return v_sat
  end

  #Resets company profit before profit for the new year is calculated
  def self.reset_profit
    cs = Company.all
    cs.each do |c|
      c.role.update_attribute(:sales_made, 0) if c.is_customer_facing?
      c.profit = 0
      c.save!
    end
  end

 
  #Resets the extra costs and accident for all companies at the beginning of a new subround
  def self.reset_extras
    cs = Company.all
    cs.each do |c|
      c.update_attributes(:extra_costs => 0, :accident_cost => 0, :break_cost => 0)
    end
  end

  #Debug method, resets all company stats
  def self.initialize_all_companies
    cs = Company.all
    cs.each do |c|
      c.revenue = 0
      c.calculate_costs
      c.profit = 0;
      if c.network
        c.belongs_to_network = true
        if c.is_customer_facing?
          c.role.belongs_to_network = true
          c.role.save
        end
      end
      c.save
    end
    nets = Network.all
    nets.each do |n|
      n.total_profit = 0
      n.score = 0
      n.save
    end
  end

  #Returns true if the company has any new notifications
  def notifications?
    contract_notifications? || rfp_notifications? || bid_notifications? || plan_notifications?
  end

  def plan_notifications?
    !self.revisions.last.nil? && !self.revisions.last.read && self.business_plan.rejected
  end

  #Returns true if there are contracts where the other party has sent a re-negotiation request
  def contract_notifications?
    contracts_as_buyer.each do |c|
      if c.under_negotiation && c.negotiation_receiver == self
        return true
      end
      if !c.decision_seen && c.negotiation_sender == self
        return true
      end
    end
    contracts_as_supplier.each do |c|
      if c.under_negotiation && c.negotiation_receiver == self
        return true
      end
      if !c.decision_seen && c.negotiation_sender == self
        return true
      end
    end
    return false
  end

  #Returns true if there are any received RFP:s that are unread
  def rfp_notifications?
    received_rfps.each do |r|
      unless r.read
        return true
      end
    end
    return false
  end

  #Returns true if there are bid notifications either from sent rfps or received rfps
  def bid_notifications?
    self.contract_processes.each do |p|
      p.bids.each do |b|
        return true if single_bid_notification?(b)
      end
    end
    return false
  end


  #Returns true if the company has received a new bid or a response to an existing bid
  def single_bid_notification?(bid)
   (!bid.read && bid.receiver == self && bid.waiting?) || (!bid.read && bid.sender == self && !bid.waiting?)
  end

  def calculate_mitigation_cost
    marketing_cost = self.marketing_cost
    unit_cost = self.calculate_parameter_cost("unit", self.role.number_of_units)
    capacity_cost = self.calculate_parameter_cost("capacity", self.role.unit_size)
    experience_cost = self.calculate_parameter_cost("experience", self.role.experience)
    total_cost = marketing_cost + unit_cost + capacity_cost + experience_cost
    puts "Total cost is #{total_cost}"

    result = (total_cost * (self.risk_mitigation/100.to_f)).round
    self.risk_control_cost = result
    return result
  end

  def calculate_max_capacity
    self.max_capacity = calculate_launch_capacity(self.capacity_cost, self.service_level, self.product_type)
  end

  #Checks if the company made more profit last year than the year before
  def made_more_profit?
    if self.company_reports.empty?
      self.profit > 0
    else
      self.profit >= self.company_reports.last.profit
    end
  end

  def service_level
    self.role.service_level
  end

  def service_level_to_s
    if self.service_level == 1
      return "Budget"
    elsif self.service_level == 3
      return "Luxury"
    else
      return "Not yet decided"
    end
  end

  def product_type
    self.role.product_type
  end

  def product_type_to_s
    if self.product_type == 1
      return "Space Hop"
    elsif self.product_type == 3
      return "Space Cruise"
    else
      return "Not yet decided"
    end
  end

  def self.get_segment_s(type, level)
    if type == 1
      if level == 1
        return "A budget flight that will quickly hop into the space for about 5 minutes"
      else
        return "A luxury flight that will spend 5 minutes in space"
      end
    else
      if level == 1
        return "A budget flight to ISS space station"
      else
        return "A luxury flight to ISS space station, including a walk in space"
      end
    end
  end
  
  def get_segment
    if self.product_type == 1
      if self.service_level == 1
        return 0
      else
        return 1
      end
    elsif self.product_type == 3
      if self.service_level == 1
        return 2
      else
        return 3
      end
    else
      return 4
    end
  end
  
  #Checks if two companies are of similar type
  def similar?(company)
    self.service_level == company.service_level && self.product_type == company.product_type
  end

  def self.get_capacity_of_launch(type, level)
    if type == 1
      if level == 1
        return 15
      else
        return 10
      end
    else
      if level == 1
        return 4
      else
        return 2
      end
    end
  end

  def max_customers
    Company.get_capacity_of_launch(self.product_type, self.service_level) * self.network.max_capacity
  end

  #Calculates if the company should incur a penalty for making changes or not
  def calculate_change_penalty
    if Game.get_game.current_round == 1
      return self.extra_costs
    else
      unless self.role.market_id_changed?
        return self.extra_costs
      else
        return  self.extra_costs + self.role.market.expansion_cost
      end
    end
  end

  #Returns the product type and service level as string so it can be compared to earlier choice
  def choice_to_s
    if self.service_level == nil || self.product_type == nil
      return nil
    end
    self.service_level.to_s + ":" + self.product_type.to_s
  end

  

  def self.calculate_results
    Company.all.reject{ |c| c.test}.each do |c|
      if c.is_customer_facing? && c.round_2_completed?
        c.revenue = c.role.sales_made * c.role.sell_price
      else
        c.revenue = c.payment_from_contracts
      end
      c.profit = c.revenue - c.total_fixed_cost -  c.total_variable_cost
      c.ebt = c.profit + c.loan_payments
      c.total_profit += c.profit
      c.capital += c.profit
      c.save!
    end
  end

  #Gets the wanted value from the limit hash
  def get_limit_hash_value(parameter, value)
    key = self.service_level.to_s + self.product_type.to_s + "_" + parameter + "_" + value
    puts key
    return self.company_type.limit_hash[key]
  end


  #Called after game values are changed to constrain all companies to new values
  def self.check_limits
    Company.all.each do |c|
      c.capacity_cost = [c.capacity_cost, c.calculate_fixed_limit(c.service_level, c.product_type, c) ].min
      c.capacity_cost = [c.capacity_cost, c.calculate_fixed_cost(c.service_level, c.product_type, c) ].max
      c.variable_cost = [c.variable_cost, Company.calculate_variable_limit(c.service_level, c.product_type, c)].min
      c.variable_cost = [c.variable_cost, Company.calculate_variable_min(c.service_level, c.product_type, c)].max
      new_limit = c.calculate_capacity_limit(c.service_level, c.product_type, c)
      c.max_capacity = new_limit if new_limit < c.max_capacity
      c.capacity_cost = c.calculate_capacity_cost(c.max_capacity)
      c.save!
    end
  end

   #Calculate the max launch capacity
  def calculate_launch_capacity(capacity_cost, level, type)
    max_cost = self.calculate_fixed_limit(level, type, self)
    min_cost = self.calculate_fixed_cost(level, type, self)
    pure_cap_increase = capacity_cost - min_cost
    max_increase = max_cost - min_cost
    max_cap = calculate_capacity_limit(level, type, self)
    return [((pure_cap_increase.to_f / max_increase.to_f) * max_cap).round,0].max
  end

  def calculate_capacity_cost(launches)
    launch_cap = calculate_capacity_limit(self.role.service_level, self.role.product_type, self)
    min_cost = calculate_fixed_cost(self.role.service_level, self.role.product_type, self)
    max_cost = self.calculate_fixed_limit(self.role.service_level, self.role.product_type, self)
    difference = max_cost - min_cost
    return [((launches.to_f / launch_cap.to_f) * difference).round + min_cost,0].max
  end


  
  def calculate_parameter_cost(parameter, amount)

    return 0 if !amount || !self.role.service_level || !self.role.product_type #No cost if that parameter is not produced

    cap = self.get_limit_hash_value(parameter, "max_size").blank? ? nil : self.get_limit_hash_value(parameter, "max_size").to_i
    min_cost = self.get_limit_hash_value(parameter, "min").blank? ? nil : self.get_limit_hash_value(parameter, "min").to_i
    max_cost = self.get_limit_hash_value(parameter, "max").blank? ? nil : self.get_limit_hash_value(parameter, "max").to_i

    return 0 if !cap || !min_cost || !max_cost

    difference = max_cost - min_cost
    return [((amount.to_f / cap.to_f) * difference).round + min_cost,0].max
  end

  



  def self.reset_extra_cost
    Company.all.each do |c|
      c.extra_costs = 0
      c.save!
    end
  end

  def get_satisfaction(market)
    return nil if market.nil?
    fixed = self.read_attribute(:fixed_sat_cost).to_f / 100.0
    var = self.variable_cost

    sat_vars = self.get_quality_variables(market)
    return 0 if sat_vars == nil
    q1 = sat_vars[0].to_f
    q2 = sat_vars[1].to_f

    return [(fixed/q2)*Math.sqrt(var/q1), 1.5].min
  end

  def get_quality_variables(market)
    vars = []
    code = ""
    code = "mark" if self.role.marketing && self.role.marketing != 0
    code = "unit" if self.role.number_of_units && self.role.number_of_units != 0
    code = "capa" if self.role.unit_size && self.role.unit_size != 0
    code = "exp" if self.role.experience && self.role.experience != 0

    return nil if code == ""

    vars << market.variables["#{code}3"]
    vars << market.variables["#{code}4"]

    return vars

   
  end

  def self.update_market_satisfactions
    Company.all.reject {|c| c.test }.each do |c|
      Market.all.reject {|m| m.test}.each do |m|
        sat = c.get_satisfaction(m)
        c.market_data[m.name] = {} if c.market_data[m.name].nil?
        c.market_data[m.name]["sat"] = sat
        c.save!
      end
    end
  end

  def get_variable_cost(customer_satisfaction)
    min_cost = Company.calculate_variable_min(self.service_level, self.product_type, self)
    max_cost = Company.calculate_variable_limit(self.service_level, self.product_type, self)
    difference = max_cost - min_cost
    amount = difference * customer_satisfaction
    return [(amount + min_cost).round, 0].max
  end

  def self.revert_changes
    Company.all.each do |c|
      earlier_version = c.previous_version
      earlier_version.save!
      if c.is_customer_facing?
        earlier_role = c.role.previous_version
        earlier_role.save!
        c.role.versions.last.destroy
      end
      c.versions.last.destroy
    end
    return nil
  end

 

  def self.set_update_flag(bool)
    Company.all.each do |c|
      c.update_attribute(:update_flag, bool)
      c.role.update_attribute(:update_flag, bool) if c.is_customer_facing?
    end
  end

  def get_ranking
    Company.where("company_type_id = ?", company_type_id).order("total_profit DESC").index(self) + 1
  end

  def launch_data_table(variable = "Launches")
    company = self
    if variable == "Sell price"
      company = self.role
    end
    axis = ['Time', variable]
    table_name = Company.variable_to_table[variable]
    datatable = []
    datatable << axis
    i = 1
    company.versions.each do |v|
      if v.event != "create"
        line = [i.to_s, v.reify.send(table_name).to_i]
        datatable << line
        i += 1
      end
    end
    line = ["current", company.send(table_name).to_i]
    datatable << line
    datatable
  end

  def report_data_table
    if !self.company_reports.empty?
      axis = ['Year', 'Profit', 'tool-profit', 'Revenue', 'tool-costs', 'Costs', 'Tool']
      i = 1
      datatable = []
      datatable << axis
      self.company_reports.order("year DESC").reverse.each do |r|
        line = [i.to_s, r.profit.to_i, "Year: #{r.year.to_s}<br/>Profit: #{number_with_delimiter r.profit.to_i, :delimiter => " "}",
        r.customer_revenue.to_i, "Year: #{r.year.to_s}<br/> Revenue: #{number_with_delimiter r.customer_revenue.to_i, :delimiter => " " }",
        r.total_cost.to_i, "Year: #{r.year.to_s}<br/>Costs: #{number_with_delimiter r.total_cost.to_i, :delimiter => " "}"]
        datatable << line
        i += 1
      end
      datatable
    else
      []
    end

  end

  def get_result_variables
    variables = ["Launches", "Fixed cost", "Variable cost", "Risk control cost"]
    if self.is_customer_facing?
      variables << "Sell price"
    end
    variables
  end

  def self.variable_to_table
    {"Launches" => "max_capacity", "Fixed cost" => "capacity_cost", "Variable cost" => "variable_cost", "Risk control cost" => "risk_control_cost", "Sell price" => "sell_price"}
  end

  def sell_price
    if self.is_customer_facing?
      return self.role.sell_price
    end
    nil
  end


  #Returns the accident the company was a part of or nil if no such accident exists
  def get_risk
    CustomerFacingRole.where("risk_id IS NOT NULL").all.each do |c|
      companies = Network.get_network(c)
      return c.risk if companies.include?(self)
    end
    return nil
  end

  def total_actual_launches
    total_launches = 0
    self.contracts_as_supplier.each do |c|
      total_launches += c.launches_made
    end
    total_launches
  end

  def self.delete_orphan_roles
    CustomerFacingRole.all.each do |c|
      c.destroy if c.company == nil
    end
    OperatorRole.all.each do |c|
      c.destroy if c.company == nil
    end
    ServiceRole.all.each do |c|
      c.destroy if c.company == nil
    end

  end

  def self.update_choices
    Company.all.each do |c|
      c.update_attribute(:earlier_choice, c.choice_to_s) if c.earlier_choice != c.choice_to_s
    end
  end

  def update_choice
    self.update_attribute(:earlier_choice, self.choice_to_s)
  end

  def self.company_data_txt
    companies = Company.all
    companies = companies.sort_by { |c| c.company_type.id  }
    text_data = ""
    companies.each do |c|
      line = c.company_type.name + ", " + c.name + ", "
      line += c.profit.to_s
      customer_facing = c.get_customer_facing_company
      if !customer_facing || customer_facing.empty?
        line += ", No market"
        customer_facing = []
      end
      customer_facing.each do |m|
        line += ", " + m.role.market.name if m.role.market
      end
      line += "<br/>"
      text_data += line
    end
    return text_data
  end

  def unread_events?
    self.events.each do |e|
      return true if !e.read
    end
    return false
  end

  def update_events
    self.events.each do |e|
      e.update_attribute(:read, true) unless e.read
    end
  end

  


  def self.assign_company_types
    Company.all.each do |c|
      if c.is_customer_facing?
        c.update_attribute(:company_type_id, 5)

      elsif c.is_operator?
        c.update_attribute(:company_type_id, 1)
      elsif c.is_tech?
        c.update_attribute(:company_type_id, 2)
      else
        c.update_attribute(:company_type_id, 4)
      end
    end
  end

  #Draws the network based on a BFT from the current node
  def get_network(year=nil)
    v = []
    q = []
    v << self
    q << self
    while !q.empty? do
      cur = q.pop
      partners = year.nil? ? (cur.buyers + cur.suppliers).uniq : (cur.buyers_from_year(year) + cur.suppliers_from_year(year)).uniq
      partners.each do |p|
        if !v.include?(p)
          v << p
          q << p
        end
      end
    end
    return v
  end

  def get_network_chunked(year=nil)
    network = self.get_network(year)
    network = network.sort_by { |c| c.company_type_id  }
    network_chunked = network.chunk { |c| c.company_type_id}.to_a
    return network_chunked
  end

  def network_constructed?
    net = self.get_network
    types = []
    net.each do |c|
      types << c.company_type if !types.include?(c.company_type)
    end
    return types.uniq.size == CompanyType.all.size
  end

  def network_ready?
    net = Company.local_network(self)
    types = []
    net.each do |c|
      types << c.company_type if !types.include?(c.company_type)
    end
    return types.uniq.size == CompanyType.all.size
  end

 


  def set_capital_validation
    @capital_validation = true
  end
  
  #Draws the local subnetwork based on a given customer facing company
  def self.local_network(customer_facing_company)
    v = []
    q = []
    v << customer_facing_company if customer_facing_company.ready?
    q << customer_facing_company
    while !q.empty? do
      cur = q.pop
      partners = cur.suppliers.uniq
      partners.each do |p|
        if !v.include?(p)
          v << p if p.ready?
          q << p
        end
      end
    end
    return v
  end

  def provide_parameter(parameter)
    capacities = {}
    total_promised = 0
    contracts = self.contracts_as_supplier.reject { |e| e.void?  }
    contracts.each do |c|
      total_promised += c.bid.get_parameter_amount(parameter)
      capacities[c.other_party(self).id] = c.bid.get_parameter_amount(parameter)
    end

    #Check if we have promised too much
    if total_promised >= self.role.parameter_value(parameter)
       split = self.role.parameter_value(parameter) / contracts.size
       extra = self.role.parameter_value(parameter) % contracts.size
 
      #Split the available amount and distribute it
       contracts.each do |c|
         if split <= c.bid.get_parameter_amount(parameter)
           capacities[c.other_party(self).id] = split
         else
           capacities[c.other_party(self).id] = c.bid.get_parameter_amount(parameter)
           extra += split - c.bid.get_parameter_amount(parameter)
         end
       end

      #Distribute the extras
      i = 0
      while extra > 0 do
        if capacities[contracts[i].other_party(self).id] < contracts[i].bid.get_parameter_amount(parameter)
          capacities[contracts[i].other_party(self).id] += 1
          extra -= 1
        end
         i = (i < contracts.size - 1) ? i + 1 : 0
      end

    end
    return capacities
  end

 #Call with customer facing company only
 #Tells how much of certain parameter ("c", "u", "e", "m") is flowing from the local network to the customer facing company
  def local_network_parameter(parameter)
    net = Company.local_network(self).reject { |c| !c.company_type.need_parameter?(parameter) }
    highest_cap = 0
    net.each do |c|
      current = c
      current_cap = 0
      con_amount = 0
      contracts = c.contracts_as_buyer.reject { |c| c.void? || c.bid.get_parameter_amount(parameter).nil? || !c.other_party(current).enough_money? }
      contracts.each do |con|
        current_cap += con.other_party(c).provide_parameter(parameter)[c.id] if con.other_party(c).company_type.produce_parameter?(parameter)
        con_amount += 1 if con.other_party(c).company_type.produce_parameter?(parameter)
      end
      decay = 0.1 * (con_amount - 1)
      current_cap *= (1.0-decay)
      highest_cap += current_cap
    end
    return highest_cap.floor
  end

  def network_marketing
    net = Company.local_network(self)
    highest_marketing = 0
    net.each do |c|
      highest_marketing = c.role.marketing if c.company_type.marketing_produce? && c.role.marketing > highest_marketing
    end
    return highest_marketing
  end

  def network_experience
    net = Company.local_network(self)
    total_experience = 0
    amount = 0
    net.each do |c|
      total_experience += c.role.experience if c.company_type.experience_produce?
      amount += 1 if c.company_type.experience_produce?
    end
    total_experience = total_experience / amount.to_f
    return total_experience.round
  end

  def experience_effect(price)
    exp = self.network_experience
    return price
  end

  def suppliers_as_chunks
    suppliers_chunked = self.suppliers.dup.sort { |c| c.company_type_id  }
    suppliers_chunked = suppliers_chunked.chunk { |c| c.company_type_id }.to_a
    suppliers_chunked
  end

  def bonus_capital_from_business_plan(grade)
    new_capital = self.capital + self.company_type.capital_bonus[grade.to_s].to_i
    puts "New capital: #{new_capital}"
    self.update_attribute(:capital, new_capital)
  end

  def organized_contracts
    contracts = self.contracts_as_buyer + self.contracts_as_supplier
    comp = self
    contracts = contracts.sort_by { |c| [c.other_party(comp).id, c.id] }
    contracts = contracts.chunk { |c| c.other_party(comp).name }
    return contracts.to_a
  end

  def test_init
    init_business_plan
  end

  def set_starting_capital
    sc = self.company_type.starting_capital ? self.company_type.starting_capital : 0
    self.capital = sc
  end

  def get_markets
    customer_facing = self.get_network.reject! { |x| !x.is_customer_facing? }
    markets = []
    customer_facing.each { |c| markets << c.role.market  }
    return markets
  end

  
  def ready?
    self.enough_money? && self.part_of_network
  end

  #TODO: Add the variable cost factor
  def enough_money?
    self.capital >= (self.total_fixed_cost - self.loan_payments)
  end

  def expand_markets(market_hash)
    expand_hash = self.expanded_markets
    cost = 0
    market_hash.each do |key, value|
      if !Market.find(key).nil? && value != "0"
        expand_hash[key] = value
        cost += Market.find(key).expansion_cost
      end
    end
    self.update_attribute(:expanded_markets, expand_hash)
    self.update_attribute(:extra_costs, self.extra_costs + cost)
  end

  def same_market?(other_company)
    markets = self.expanded_markets.keys
    markets << self.role.market.id.to_s if self.role.market
    other_markets = other_company.expanded_markets.keys
    other_markets << other_company.role.market.id.to_s if other_company.role.market
    return !(markets & other_markets).empty?
  end

  def all_markets
    all = []
    markets = self.expanded_markets.keys
    all << self.role.market.name if self.role.market
    markets.each { |m| all << Market.find(m).name }
    return all
  end

  def all_markets_obj
    all = []
    markets = self.expanded_markets.keys
    all << self.role.market if self.role.market
    markets.each { |m| all << Market.find(m) }
    return all
  end

  def variable_expansion_costs
    return 0
  end

 

  def self.rank_companies
    ranked_companies = {}
    Company.order("company_type_id").chunk { |x| x.company_type_id }.each do |key, value|
      ranked_companies[key] = value.sort_by { |c| -c.total_profit }
    end
    return ranked_companies
  end

  def loan_payments
    payments = 0
    self.loans.all.each do |l|
      payments += l.get_payment if l.remaining && l.remaining > 0
    end
    return payments
  end

  def new_loans
    total = 0
    loans = self.loans.all.reject { |l| l.duration != l.remaining  }
    loans.each do |l|
      total = l.loan_amount
    end
    return total
  end

  #Calculates the total network cost of the test network
  def test_network_cost(launches)
    net = Company.local_network(self)
    costs = 0
    net.each do |c|
      costs += c.total_fixed_cost + launches * c.variable_cost
    end
    return costs
  end


  private

  #Initialises a business plan for the company
  def init_business_plan
    plan = self.create_business_plan
    resp_areas = User.position_resp_areas
    User.positions.each do |pos|
      resp_areas[pos].each do |t|
        part = plan.plan_parts.create
        part.position = pos
        puts "Pos: #{pos}"
        part.title = t
        part.save
      end
    end
    part = plan.plan_parts.create
    part.position = PlanPart.free
    part.title = "Reasoning"
    part.save
  end

  


  
  
  #Checks if this company has made contracts
  def has_contracts?
    return !self.contracts_as_buyer.empty? || !self.contracts_as_supplier.empty?
  end



  def capital_validation
    if self.capital < self.total_fixed_cost
      errors.add(:capital, "Cannot afford these settings")
    end
  end

  

  def capital_validation?
    @capital_validation
  end

  
    
  
end
