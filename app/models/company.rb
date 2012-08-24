class Company < ActiveRecord::Base
  
  after_create :init_business_plan
  
  attr_accessible :name, :group_id, :service_type, :risk_control_cost, :capacity_cost, :variable_cost,  :about_us, :operator_role_attributes, :customer_facing_role_attributes, :service_role_attributes
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
      if self.network && self.role.sell_price
        true
      else
        false
      end
    else
      if self.network
        true
      else
        false
      end
    end
  end

  #Rejects all bid with the "Waiting" status with all companies with the type given as a parameter
  #This is called after accepting a bid from a certain company type, since only one contract can be formed between
  #certain company types
  def reject_all_standing_bids_with_type(company_service_type)
    bids = Bid.where(:status => Bid.waiting)
    bids.each do |bid|
      if self.id == bid.sender.id && bid.receiver.service_type == company_service_type
        bid.status = Bid.rejected
        bid.save
      end
      if self.id == bid.receiver.id && bid.sender.service_type == company_service_type
        bid.status = Bid.rejected
        bid.save
      end
    end 
  end

  #Returns a hash containing company fixed and variable cost depending on company choices
  def get_stat_hash(level, type, risk_cost, capacity_cost, variable_cost)
    stat_hash = {}
    stat_hash["fixed_cost"] = calculate_fixed_cost(level, type)
    stat_hash["variable_cost"] = variable_cost
    stat_hash["risk_cost"] = risk_cost
    stat_hash["capacity_cost"] = capacity_cost
    stat_hash["service_level"] = level
    stat_hash["product_type"] = type
    stat_hash["launch_capacity"] = calculate_launch_capacity(capacity_cost, stat_hash["fixed_cost"])
    stat_hash["variable_limit"] = Company.calculate_variable_limit(level, type)
    self.role.service_level = level
    self.role.product_type = type
    self.risk_control_cost = risk_cost
    self.capacity_cost = capacity_cost
    self.variable_cost = variable_cost
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
    self.fixed_cost = calculate_fixed_cost(level, type)
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
    self.fixed_cost + self.risk_control_cost + self.capacity_cost + self.extra_costs
  end

  #Returns revenue generated from the contracts as provider
  def contract_revenue
    contract_revenue = 0
    contracts_as_supplier.each do |c|
      contract_revenue += c.amount
    end
    contract_revenue
  end

  #Returns total revenue of the company
  def total_revenue
    revenue + contract_revenue
  end

  #Returns the total variable cost of the company that is formed by own selected variable cost, and cost from contracts
  def total_variable_cost
      return variable_cost + contract_variable_cost
  end

  def create_report
    report = self.company_reports.create
    report.year = Game.get_game.sub_round - 1
    report.profit = self.profit
    report.customer_revenue = self.revenue
    report.contract_revenue = self.contract_revenue
    report.base_fixed_cost = self.fixed_cost
    report.risk_control = self.risk_control_cost
    report.contract_cost = self.contract_variable_cost
    report.variable_cost = self.variable_cost
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

  #Returns true if the company has received a new bid or a response to an existing bid
  def single_bid_notification?(bid)
   (!bid.read && bid.receiver == self && bid.waiting?) || (!bid.read && bid.sender == self && !bid.waiting?)
  end

  def calculate_mitigation
    self.risk_mitigation = ((self.risk_control_cost.to_f / self.fixed_cost) * 100).to_i
  end

  def calculate_max_capacity
    self.max_capacity = calculate_launch_capacity(self.capacity_cost, self.fixed_cost)
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

  def product_type
    self.role.product_type
  end
  
  #Checks if two companies are of similar type
  def similar?(company)
    self.service_level == company.service_level && self.product_type == company.product_type
  end

  #Dummy method, TODO implement proper
  def self.get_capacity_of_launch
    5
  end

  def max_customers
    Company.get_capacity_of_launch * self.network.max_capacity
  end

  #Calculates if the company should incur a penalty for making changes or not
  def calculate_change_penalty
    if !self.values_decided || (!self.changed? && !self.role.changed?)
      0
    else
      if self.role.changed? && self.role.changed.size == 1 && self.role.changed.first == "sell_price" && !self.changed?
        0
      else
        1000000
      end
    end
  end

  #Calculate profit for all companies based on revenue and costs
  def self.calculate_profit
    Company.all.each do |c|
      if c.values_decided?
        if c.network
          launches = c.network.sales / Company.get_capacity_of_launch
          c.profit = c.revenue - c.total_fixed_cost - (launches * c.total_variable_cost)
          c.total_profit += c.profit
          c.extra_costs = 0
          c.save!
        else
          c.profit = -c.total_fixed_cost
          c.total_profit += c.profit
          c.extra_costs = 0
          c.save!
        end
      end
    end
  end

  #Calculates the upper limit for variable cost
  #It is dependant on level and type
  def self.calculate_variable_limit(level, type)
    if level == 1 && type == 1
      return 200000
    elsif level == 3 && type == 1
      return 400000
    elsif level == 1 && type == 3
      return 20000000
    else
      return 35000000
    end
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

  #Calculates the fixed costs of the company depending on company choices
  def calculate_fixed_cost(level, type)
    if level == 1 && type == 1
      1000000
    elsif level == 3 && type == 1
      2000000
    elsif level == 1 && type == 3
      20000000
    else
      40000000
    end
  end

  #Calculate the max launch capacity, currently just placeholder
  def calculate_launch_capacity(capacity_cost, fixed_cost)
    return ((capacity_cost.to_f / fixed_cost)*100).to_i
  end

  
    
  
end
# == Schema Information
#
# Table name: companies
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  fixed_cost         :decimal(20, 2)  default(0.0)
#  variable_cost      :decimal(20, 2)  default(0.0)
#  revenue            :decimal(20, 2)  default(0.0)
#  profit             :decimal(20, 2)  default(0.0)    //Profit made by the company in the last fiscal year
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  group_id           :integer
#  about_us           :text
#  assets             :decimal(20, 2)  default(0.0)
#  network_id         :integer
#  belongs_to_network :boolean         default(FALSE)
#  service_type       :string(255)
#  initialised        :boolean         default(FALSE)
#  for_investors      :text
#  risk_control_cost  :decimal(20, 2)  default(0.0)
#  risk_mitigation    :integer         default(0)
#  max_capacity       :integer         default(0)
#  capacity_cost      :decimal(20, 2)  default(0.0)
#  values_decided     :boolean         default(FALSE)
#  extra_costs        :decimal(20, 2)  default(0.0)
#  total_profit       :decimal(20, 2)  default(0.0)     //Total Profit made by the company
#

