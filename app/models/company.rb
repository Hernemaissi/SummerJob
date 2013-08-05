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
#

class Company < ActiveRecord::Base
  has_paper_trail :only => [:update_flag]

  
  after_create :init_business_plan
  
  attr_accessible :name, :group_id, :service_type, :risk_control_cost, :risk_mitigation, :capacity_cost, :variable_cost,  :about_us, :operator_role_attributes, :customer_facing_role_attributes, :service_role_attributes, :max_capacity
  belongs_to :group
  belongs_to :network
  has_one :business_plan, :dependent => :destroy
  has_many :revisions, :dependent => :destroy
  has_many :company_reports, :dependent => :destroy
  has_one :operator_role, :dependent => :destroy
  has_one :customer_facing_role, :dependent => :destroy
  has_one :service_role, :dependent => :destroy
  accepts_nested_attributes_for :operator_role, :customer_facing_role, :service_role
  
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

  has_many :buyers, :through => :contracts_as_supplier, :source => :service_buyer
  has_many :suppliers, :through => :contracts_as_buyer, :source => :service_provider
                  

  validate :validate_no_change_in_level_type_after_contract, :on => :update
  validate :max_capacity_in_limits, :on => :update


  validates :name, presence: true,:length=> 5..20
  validates :group_id, presence: true
  validates :fixed_cost, presence: true
  validates :variable_cost, presence: true
  validates :revenue, presence: true
  validates :profit, presence: true

  

  #Returns the correct role model of the company, depending on company type
  def role
    if self.service_type == "Customer"
      return self.customer_facing_role
    elsif self.service_type == "Operator"
      return self.operator_role
    else
      return self.service_role
    end
  end

  #Creates a role for the company, depending on company type
  def create_role
    if self.is_customer_facing?
      role = self.create_customer_facing_role(:service_level => 1)
      role.save
    elsif self.is_operator?
      role = self.create_operator_role(:service_level => 1, :specialized => false)
      role.save
    else
      role = self.create_service_role(:service_level => 1, :specialized => false, :service_type => self.service_type)
      role.save
    end
  end

  #Destroys the role of the company, depending on type
  def destroy_role
    if self.role
      if self.is_customer_facing?
        CustomerFacingRole.destroy(self.role.id)
      elsif self.is_operator?
        OperatorRole.destroy(self.role.id)
      else
        ServiceRole.destroy(self.role.id)
      end
    end
  end

  #Returns true if the company is customer facing company
  def is_customer_facing?
    self.service_type == "Customer"
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
  
  def self.search_fields
      ['Name', 'Student Number', "Department"]
  end

  def self.rfp_targets
    Hash["Operator", "Marketing, Technology, Supply", "Customer", "Operator", "Technology", "Operator", "Supplier", "Operator"]
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
    contracts_as_supplier.find_by_service_buyer_id(other_company.id)
  end

  #Returns true if the company has made a contract with the company given as parameter
  def has_contract_with?(other_company)
    if !provides_to?(other_company)
      other_company.provides_to?(self)
    else
      true
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
  def has_contract_with_type?(company_service_type)
    companies = Company.where("service_type = ?", company_service_type)
    companies.each do |c|
      if has_contract_with?(c)
        return true
      end
    end
    return false
  end

  #New algorithm for checking if company is part of a network, has to be dynamic now that networks change
  def part_of_network()
    if self.service_type == Company.types[0]  #Customer facing
      if !self.suppliers.empty?
        self.suppliers.each do |o|
          if o.operator_networked?
            return true
          end
        end
        return false
      else
        return false
      end
    elsif self.service_type == Company.types[1] # Operator
      return self.operator_networked?
    else                                                              #Service
      if !self.buyers.empty?
        self.buyers.each do |o|
          if o.operator_networked?
            return true
          end
        end
        return false
      else
        return false
      end
    end
  end

  #Checks if the operator is networked, should only be called for operator type companies
  def operator_networked?
    self.has_contract_with_type?(Company.types[0]) && self.has_contract_with_type?(Company.types[2]) && self.has_contract_with_type?(Company.types[3])
  end

  #Returns a customer facing company of the network or nil if it doesn't have one
  def get_customer_facing_company
    if self.is_customer_facing?
      return self
    end
    if self.is_operator?
      customer_partners = self.buyers
      if !customer_partners.empty?
        return customer_partners.first
      else
        return nil
      end
    else
      operator_partners = self.buyers
      if !operator_partners.empty?
        operator_partners.each do |o|
          customer_partners = o.buyers
          if !customer_partners.empty?
            return customer_partners.first
          end
        end
        return nil
      else
        return nil
      end
    end
  end

  #TODO: total launches operators are able to provide depends on tech and supply
  #Gets total launches of a dynamic network, customer facing company is used as root
  # Should only be called for customer facing company
  def network_launches
    if !self.is_customer_facing?
      return 0
    end
    operator_total = 0
    self.suppliers.each do |o|
      tech_total = 0
      supply_total = 0
      operator_provides = o.contracts_as_supplier.find_by_service_buyer_id(self.id).actual_launches
      o.suppliers.where("service_type = ?", "Technology").each do |t|
        tech_total += o.contracts_as_buyer.find_by_service_provider_id(t.id).actual_launches
      end
      o.suppliers.where("service_type = ?", "Supplier").each do |s|
        supply_total += o.contracts_as_buyer.find_by_service_provider_id(s.id).actual_launches
      end
      puts "Operator_provides: #{operator_provides}\n"
      puts "Tech total: #{tech_total}\n"
      puts "Supply total: #{supply_total}\n"
      operator_total += [tech_total, supply_total, operator_provides].min
    end
    puts "Operator_total: #{operator_total}\n"
    return [self.max_capacity, operator_total].min
  end

  def self.save_launches
    Company.where("service_type = ?", Company.types[0]).each do |c|
      launches = c.role.get_launches
      c.distribute_launches(launches)
      Company.update_launches_made
    end
  end

  

  #TODO: Consider skip situation to avoid (technically impossible) endless loop
  def distribute_launches(launches)
    company = nil
    if self.is_customer_facing?
      company = self
    else
      company = get_customer_facing_company
    end
    if company && company.part_of_network
      company.update_attribute(:launches_made, launches)
      operator_contracts = company.contracts_as_buyer.all.shuffle.dup
      i = 0
      puts "Operator Contracts size: #{operator_contracts.size}"
      while launches > 0 && !operator_contracts.empty?
        if operator_contracts[i].launches_made < operator_contracts[i].service_provider.actual_operator_capacity(operator_contracts[i].service_buyer)
          operator_contracts[i].launches_made += 1
          launches -= 1
        end
        i = (i+1 >= operator_contracts.size) ? 0 : i+1
        
      end

      operator_contracts.each do |c|
        c.save(validate: false)
        launches = c.launches_made
        tech_contracts = c.service_provider.contracts_as_buyer.joins(:service_provider).where(:companies => {:service_type => Company.types[2]}).readonly(false).all.shuffle.dup
        i = 0
        puts "Tech Contracts size: #{tech_contracts.size}"
        while launches > 0 && !tech_contracts.empty?
          if tech_contracts[i].launches_made < tech_contracts[i].actual_launches
            tech_contracts[i].launches_made += 1
            launches -= 1
          end
          i = (i+1 >= tech_contracts.size) ? 0 : i+1
        end

        tech_contracts.each do |t|
          t.save(validate: false)
        end

        launches = c.launches_made
        supply_contracts = c.service_provider.contracts_as_buyer.joins(:service_provider).where(:companies => {:service_type => Company.types[3]}).readonly(false).all.shuffle.dup
        i = 0
        while launches > 0 && !supply_contracts.empty?
          if supply_contracts[i].launches_made < supply_contracts[i].actual_launches
            supply_contracts[i].launches_made += 1
            launches -= 1
          end
          i = (i+1 >= supply_contracts.size) ? 0 : i+1
        end

        supply_contracts.each do |s|
          s.save(validate: false)
        end

      end
      
    end
  end

  def self.update_launches_made
    Company.all.each do |c|
      unless c.is_customer_facing?
        total_launches = c.contracts_as_supplier.sum('launches_made')
        c.update_attribute(:launches_made, total_launches)
      end
    end
  end


  def self.reset_launches_made
    Company.all.each do |c|
      c.launches_made = 0
      c.save(validate: false)
      c.contracts_as_buyer.each do |con|
        con.update_attribute(:launches_made, 0)
      end
    end
  end

  #Defines the actual capacity a operator is able to provide to a customer
  def actual_operator_capacity(customer)
    if !self.is_operator? || !customer.is_customer_facing?
      return 0
    end
    tech_capacity = 0
    self.suppliers.where("service_type = ?", Company.types[2]).each do |t|
      tech_capacity += self.contracts_as_buyer.find_by_service_provider_id(t.id).actual_launches
    end
    supply_capacity = 0
    self.suppliers.where("service_type = ?", Company.types[3]).each do |s|
      supply_capacity += self.contracts_as_buyer.find_by_service_provider_id(s.id).actual_launches
    end
    promised_launches = self.contracts_as_supplier.find_by_service_buyer_id(customer.id).actual_launches
    return [promised_launches, tech_capacity, supply_capacity].min
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

  #Returns true if the company's business plan has been verified by the teacher
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



  #Returns a hash containing company fixed and variable cost depending on company choices
  def get_stat_hash(level, type, risk_mit, launches, variable_cost, sell_price, market_id)
    stat_hash = {}
    self.role.service_level = level
    self.role.product_type = type
    stat_hash["fixed_cost"] = calculate_fixed_cost(level, type, self)
    stat_hash["variable_cost"] = variable_cost
    stat_hash["launch_capacity"] = launches
    stat_hash["service_level"] = level
    stat_hash["product_type"] = type
    stat_hash["capacity_cost"] = calculate_capacity_cost(launches)
    stat_hash["variable_limit"] = Company.calculate_variable_limit(level, type, self)
    stat_hash["variable_min"] = Company.calculate_variable_min(level, type, self)
    stat_hash["sell_price"] = sell_price
    self.capacity_cost =  stat_hash["capacity_cost"]
    self.risk_mitigation = risk_mit
    self.calculate_mitigation_cost
    stat_hash["risk_cost"] = self.risk_control_cost
    self.variable_cost = variable_cost
    if self.customer_facing_role
      self.role.market_id = market_id
    end
    stat_hash["change_penalty"] = calculate_change_penalty
    stat_hash
  end

  #Calculates the extra costs for the company, which only affect the current year
  def get_extra_cost
    self.extra_costs += calculate_change_penalty
  end

  #Calculates the costs for the company depending on company choices
  def calculate_costs
    level = self.role.service_level
    type = self.role.product_type
    self.fixed_cost = calculate_fixed_cost(level, type, self)
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
    self.risk_control_cost + self.capacity_cost + self.extra_costs
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
      contract_revenue += c.amount * c.launches_made
    end
    return contract_revenue
  end

  def payment_to_contracts
    contract_cost = 0
    contracts_as_buyer.each do |c|
      contract_cost += c.amount * c.launches_made
    end
    return contract_cost
  end

  #Returns total revenue of the company
  def total_revenue
    revenue + contract_revenue
  end

  #Returns the total variable cost of the company that is formed by own selected variable cost, and cost from contracts
  def total_variable_cost
      return variable_cost + contract_variable_cost
  end

  #Creates a yearly report for the company
  #Takes a extra cost as a parameter because at this point it has already been reset
  def create_report
    report = self.company_reports.create
    report.year = Game.get_game.sub_round
    report.profit = self.profit
    report.customer_revenue = self.revenue
    report.contract_revenue = self.contract_revenue
    report.base_fixed_cost = self.fixed_cost
    report.risk_control = self.risk_control_cost
    report.contract_cost = self.payment_from_contracts
    report.variable_cost = self.variable_cost
    report.launch_capacity_cost = self.capacity_cost
    report.extra_cost = self.extra_costs
    report.launches = self.launches_made
    report.save!
  end

  #Resets company profit before profit for the new year is calculated
  def self.reset_profit
    cs = Company.all
    cs.each do |c|
      c.profit = 0
      c.save!
    end
  end

  #Resets the extra costs for all companies at the beginning of a new subround
  def self.reset_extras
    cs = Company.all
    cs.each do |c|
      c.update_attribute(:extra_costs, 0)
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
    contract_notifications? || rfp_notifications? || bid_notifications?
  end

  #Returns true if there are contracts where the other party has sent a re-negotiation request
  def contract_notifications?
    contracts_as_buyer.each do |c|
      if c.under_negotiation && c.negotiation_receiver == self
        return true
      end
    end
    contracts_as_supplier.each do |c|
      if c.under_negotiation && c.negotiation_receiver == self
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
    sent_rfp_bid_notifications? || received_rfp_bid_notifications?
  end


  #Returns true if there is a bid notification in bids associated with sent rfps
  def sent_rfp_bid_notifications?
    sent_rfps.each do |r|
      r.bids.each do |bid|
        if single_bid_notification?(bid)
          return true
        end
      end
    end
    return false
  end

  #Returns true if there is a bid notification in bids associated with received rfps
  def received_rfp_bid_notifications?
    received_rfps.each do |r|
      r.bids.each do |bid|
        if single_bid_notification?(bid)
          return true
        end
      end
    end
    return false
  end

  #Returns if there is notification associated with a specific RFP
  def single_rfp_notification?(rfp)
    return true unless rfp.read
    rfp.bids.each do |b|
      if single_bid_notification?(b)
        return true
      end
    end
    return false
  end

  #Returns true if the company has received a new bid or a response to an existing bid
  def single_bid_notification?(bid)
   (!bid.read && bid.receiver == self && bid.waiting?) || (!bid.read && bid.sender == self && !bid.waiting?)
  end

  def calculate_mitigation_cost
    self.risk_control_cost = self.calculate_quality_costs
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
    else
      return "Luxury"
    end
  end

  def product_type
    self.role.product_type
  end

  def product_type_to_s
    if self.product_type == 1
      return "Space Hop"
    else
      return "Space Cruise"
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
    else
      if self.service_level == 1
        return 2
      else
        return 3
      end
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
    if self.extra_costs != 0
      return 1000000
    end
    if Game.get_game.current_round == 1
      0
    else
      if (!self.role.changed? || (self.role.changed? && self.role.changed.size == 1 && self.role.changed.first == "sell_price"))
        0
      else
        1000000
      end
    end
  end

  

  def self.calculate_results
    Company.all.each do |c|
      if c.is_customer_facing? && c.round_2_completed?
        c.revenue = c.role.sales_made * c.role.sell_price
      else
        c.revenue = c.payment_from_contracts
      end
      c.profit = c.revenue - c.total_fixed_cost - (c.launches_made * c.total_variable_cost)
      c.total_profit += c.profit
      c.save!
    end
  end

  #Calculates the upper limit for variable cost
  #It is dependant on level and type
  def self.calculate_variable_limit(level, type, company)
    if level == 1 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_budget_var_max_customer
       elsif company.is_operator?
         return Game.get_game.low_budget_var_max_operator
       elsif company.is_tech?
         return Game.get_game.low_budget_var_max_tech
      else
        return Game.get_game.low_budget_var_max_supply
      end
      
    elsif level == 3 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_luxury_var_max_customer
       elsif company.is_operator?
         return Game.get_game.low_luxury_var_max_operator
       elsif company.is_tech?
         return Game.get_game.low_luxury_var_max_tech
      else
        return Game.get_game.low_luxury_var_max_supply
      end
      
    elsif level == 1 && type == 3
       if company.is_customer_facing?
         return Game.get_game.high_budget_var_max_customer
       elsif company.is_operator?
         return Game.get_game.high_budget_var_max_operator
       elsif company.is_tech?
         return Game.get_game.high_budget_var_max_tech
      else
       return Game.get_game.high_budget_var_max_supply
      end
      
    else
      if company.is_customer_facing?
         return Game.get_game.high_luxury_var_max_customer
       elsif company.is_operator?
         return Game.get_game.high_luxury_var_max_operator
       elsif company.is_tech?
         return Game.get_game.high_luxury_var_max_tech
      else
       return Game.get_game.high_luxury_var_max_supply
      end
      
    end
  end

  #Calculates lower limit for variable cost
  def self.calculate_variable_min(level, type, company)
    if level == 1 && type == 1
       if company.is_customer_facing?
         return Game.get_game.low_budget_var_min_customer
       elsif company.is_operator?
         return Game.get_game.low_budget_var_min_operator
       elsif company.is_tech?
         return Game.get_game.low_budget_var_min_tech
      else
       return Game.get_game.low_budget_var_min_supply
      end
      
    elsif level == 3 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_luxury_var_min_customer
       elsif company.is_operator?
         return Game.get_game.low_luxury_var_min_operator
       elsif company.is_tech?
         return Game.get_game.low_luxury_var_min_tech
      else
       return Game.get_game.low_luxury_var_min_supply
      end
      
    elsif level == 1 && type == 3
      if company.is_customer_facing?
         return Game.get_game.high_budget_var_min_customer
       elsif company.is_operator?
         return Game.get_game.high_budget_var_min_operator
       elsif company.is_tech?
         return Game.get_game.high_budget_var_min_tech
      else
       return Game.get_game.high_budget_var_min_supply
      end
      
    else
      if company.is_customer_facing?
         return Game.get_game.high_luxury_var_min_customer
       elsif company.is_operator?
         return Game.get_game.high_luxury_var_min_operator
       elsif company.is_tech?
         return Game.get_game.high_luxury_var_min_tech
      else
       return Game.get_game.high_luxury_var_min_supply
      end
      
    end
  end

  #Checks if changing the business model is allowed
  def can_change_business_model
    (!self.role.service_level_changed? && !self.role.product_type_changed?) || !has_contracts?
  end

    #Calculates the fixed lower costs of the company depending on company choices
  def calculate_fixed_cost(level, type, company)
    if level == 1 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_budget_min_customer
       elsif company.is_operator?
         return Game.get_game.low_budget_min_operator
       elsif company.is_tech?
         return Game.get_game.low_budget_min_tech
      else
        return Game.get_game.low_budget_min_supply
      end
    elsif level == 3 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_luxury_min_customer
       elsif company.is_operator?
         return Game.get_game.low_luxury_min_operator
       elsif company.is_tech?
         return Game.get_game.low_luxury_min_tech
      else
        return Game.get_game.low_luxury_min_supply
      end
      
    elsif level == 1 && type == 3
      if company.is_customer_facing?
         return Game.get_game.high_budget_min_customer
       elsif company.is_operator?
         return Game.get_game.high_budget_min_operator
       elsif company.is_tech?
         return Game.get_game.high_budget_min_tech
      else
        return Game.get_game.high_budget_min_supply
      end
       
    else
      if company.is_customer_facing?
         return Game.get_game.high_luxury_min_customer
       elsif company.is_operator?
         return Game.get_game.high_luxury_min_operator
       elsif company.is_tech?
         return Game.get_game.high_luxury_min_tech
      else
        return Game.get_game.high_luxury_min_supply
      end
      
    end
  end

   #Calculates the fixed max costs of the company depending on company choices
  def calculate_fixed_limit(level, type, company)
    if level == 1 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_budget_max_customer
       elsif company.is_operator?
         return Game.get_game.low_budget_max_operator
       elsif company.is_tech?
         return Game.get_game.low_budget_max_tech
      else
        return Game.get_game.low_budget_max_supply
      end
      
    elsif level == 3 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_luxury_max_customer
       elsif company.is_operator?
         return Game.get_game.low_luxury_max_operator
       elsif company.is_tech?
         return Game.get_game.low_luxury_max_tech
      else
        return Game.get_game.low_luxury_max_supply
      end
      
    elsif level == 1 && type == 3
      if company.is_customer_facing?
         return Game.get_game.high_budget_max_customer
       elsif company.is_operator?
         return Game.get_game.high_budget_max_operator
       elsif company.is_tech?
         return Game.get_game.high_budget_max_tech
      else
        return Game.get_game.high_budget_max_supply
      end
       
    else
      if company.is_customer_facing?
         return Game.get_game.high_luxury_max_customer
       elsif company.is_operator?
         return Game.get_game.high_luxury_max_operator
       elsif company.is_tech?
         return Game.get_game.high_luxury_max_tech
      else
        return Game.get_game.high_luxury_max_supply
      end
      
    end
  end

   #Returns the maximum capacity inputed in the system
  def calculate_capacity_limit(level, type, company)
    if level == 1 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_budget_cap_customer
       elsif company.is_operator?
         return Game.get_game.low_budget_cap_operator
       elsif company.is_tech?
         return Game.get_game.low_budget_cap_tech
      else
        return Game.get_game.low_budget_cap_supply
      end
      
    elsif level == 3 && type == 1
      if company.is_customer_facing?
         return Game.get_game.low_luxury_cap_customer
       elsif company.is_operator?
         return Game.get_game.low_luxury_cap_operator
       elsif company.is_tech?
         return Game.get_game.low_luxury_cap_tech
      else
        return Game.get_game.low_luxury_cap_supply
      end
      
    elsif level == 1 && type == 3
      if company.is_customer_facing?
         return Game.get_game.high_budget_cap_customer
       elsif company.is_operator?
         return Game.get_game.high_budget_cap_operator
       elsif company.is_tech?
         return Game.get_game.high_budget_cap_tech
      else
        return Game.get_game.high_budget_cap_supply
      end
       
    else
      if company.is_customer_facing?
         return Game.get_game.high_luxury_cap_customer
       elsif company.is_operator?
         return Game.get_game.high_luxury_cap_operator
       elsif company.is_tech?
         return Game.get_game.high_luxury_cap_tech
      else
        return Game.get_game.high_luxury_cap_supply
      end
      
    end
  end

  #Called after game values are changed to constrain all companies to new values
  def self.check_limits
    Company.all.each do |c|
      c.capacity_cost = [c.capacity_cost, c.calculate_fixed_limit(c.service_level, c.product_type, c) ].min
      c.capacity_cost = [c.capacity_cost, c.calculate_fixed_cost(c.service_level, c.product_type, c) ].max
      c.variable_cost = [c.variable_cost, Company.calculate_variable_limit(c.service_level, c.product_type, c)].min
      c.variable_cost = [c.variable_cost, Company.calculate_variable_min(c.service_level, c.product_type, c)].max
      c.max_capacity = c.calculate_launch_capacity(c.capacity_cost, c.service_level, c.product_type)
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

  def calculate_quality_costs
    self.risk_control_cost = (self.capacity_cost * (self.risk_mitigation/100.to_f)).round
  end

  def self.reset_extra_cost
    Company.all.each do |c|
      c.extra_costs = 0
      c.save!
    end
  end

  def get_satisfaction
    min_cost = Company.calculate_variable_min(self.service_level, self.product_type, self)
    actual_investment = self.variable_cost - min_cost
    actual_max = Company.calculate_variable_limit(self.service_level, self.product_type, self) - min_cost
    return actual_investment.to_f / actual_max
  end

  def self.revert_changes
    Company.all.each do |c|
      earlier_version = c.previous_version
      earlier_version.save!
    end
    return nil
  end

  def self.set_update_flag(bool)
    Company.all.each do |c|
      c.update_attribute(:update_flag, bool)
    end
  end

  def get_ranking
    Company.where("service_type = ?", service_type).order("total_profit").index(self)
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
    company.versions.order("created_at DESC").limit(3).reverse.each do |v|
      line = [i.to_s, v.reify.send(table_name).to_i]
      datatable << line
      i += 1
    end
    line = [i.to_s, company.send(table_name).to_i]
    datatable << line
    datatable
  end

  def report_data_table
    axis = ['Year', 'Profit', 'Revenue', 'Costs']
    i = 1
    datatable = []
    datatable << axis
    self.company_reports.order("year DESC").limit(3).reverse.each do |r|
      line = [i.to_s, r.profit.to_i, r.customer_revenue.to_i, r.total_cost.to_i]
      datatable << line
      i += 1
    end
    datatable
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

  def distance(other_company)
    distance = 0
    if self.service_level != other_company.service_level
      distance += 1
    end
    if self.product_type != other_company.product_type
      distance +=1
    end
    distance
  end

  #Returns the accident the company was a part of or nil if no such accident exists
  def get_risk
    CustomerFacingRole.where("risk_id IS NOT NULL").all.each do |c|
      companies = Network.get_network(c)
      return c.risk if companies.include?(self)
    end
    return nil
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

  def validate_no_change_in_level_type_after_contract
    if (self.role.service_level_changed? || self.role.product_type_changed?) && has_contracts?
        errors.add(:base, "You cannot change business model (service level or product type) if you have already made a contract with someone")
    end
  end

  def max_capacity_in_limits
    if self.max_capacity < 0 || self.max_capacity > self.calculate_capacity_limit(self.service_level, self.product_type, self)
      errors.add(:base, "Launch capacity must be between 0 and #{self.calculate_capacity_limit(self.service_level, self.product_type, self)}");
    end
  end

  
    
  
end
