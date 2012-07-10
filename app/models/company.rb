class Company < ActiveRecord::Base
  
  after_create :init_business_plan
  
  attr_accessible :name, :group_id, :service_type,  :about_us, :operator_role_attributes, :customer_facing_role_attributes, :service_role_attributes
  belongs_to :group
  belongs_to :network
  has_one :business_plan, :dependent => :destroy
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
  validates :fixedCost, presence: true
  validates :variableCost, presence: true
  validates :revenue, presence: true
  validates :profit, presence: true

  def role
    if self.service_type == "Customer"
      return self.customer_facing_role
    elsif self.service_type == "Operator"
      return self.operator_role
    else
      return self.service_role
    end
  end

  def create_role
    if self.is_customer_facing?
      role = self.create_customer_facing_role(:promised_service_level => 1)
      role.save
    elsif self.is_operator?
      role = self.create_operator_role(:service_level => 1, :specialized => false)
      role.save
    else
      role = self.create_service_role(:service_level => 1, :specialized => false, :service_type => self.service_type)
      role.save
    end
  end

  def is_customer_facing?
    self.service_type == "Customer"
  end

  def is_operator?
    self.service_type == "Operator"
  end

  def is_service?
    !self.is_operator? && !self.is_customer_facing?
  end

  def is_tech?
    self.service_type == "Technology"
  end

  def is_supply?
    self.service_type == "Supplier"
  end
  
  def self.types
    ['Customer', 'Operator', 'Technology', 'Supplier']
  end
  
  def self.search_fields
      ['Name', 'Student Number', "Department"]
  end
  
  def send_rfp!(other_company, content)
    sent_rfps.create!(receiver_id: other_company.id, content: content)
  end
  
  def has_sent_rfp?(other_company)
    sent_rfps.find_by_receiver_id(other_company.id)
  end
  
  
  def provides_to?(other_company)
    contracts_as_supplier.find_by_service_buyer_id(other_company.id)
  end
  
  def has_contract_with?(other_company)
    if !provides_to?(other_company)
      other_company.provides_to?(self)
    else
      true
    end
  end
  
  def self.search(field, query)
    name = 0
    student_number = 1
    department = 2
    if field == Company.search_fields[name]
      return Company.where('name LIKE ?', "%#{query}%")
    elsif field == Company.search_fields[student_number]
      return Company.where('studentNumber LIKE ?', "%#{query}%")
    elsif field == Company.search_fields[department]
      return Company.where('department LIKE ?',  "%#{query}%")
    else
      return []
    end
  end

  def has_contract_with_type?(company_service_type)
    companies = Company.where("service_type = ?", company_service_type)
    companies.each do |c|
      if has_contract_with?(c)
        return true
      end
    end
    return false
  end
  
  def round_1_completed?
    business_plan.verified?
  end

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

  def get_stat_hash(level, capacity, type, specialized)
    stat_hash = {}
    stat_hash["fixed_cost"] = calculate_fixed_cost(level, capacity, type, specialized)
    stat_hash["variable_cost"] = calculate_variable_cost(level, capacity, type, specialized)
    stat_hash
  end

  def calculate_costs
    level = (!self.is_customer_facing?) ? self.role.service_level : 1
    capacity = (self.is_operator?) ? self.role.capacity : 1
    type = (self.is_operator?) ? self.role.product_type : 1
    specialized = (!self.is_customer_facing?) ? self.role.specialized : false
    customer_facing = self.is_customer_facing?
    stat_hash = get_stat_hash(level, capacity, type, specialized)
    self.fixedCost = stat_hash["fixed_cost"]
    self.variableCost = stat_hash["variable_cost"]
  end
  
  def contract_fixed_cost
    contract_fixed_cost = 0
    contracts_as_buyer.each do |c|
      contract_fixed_cost += c.amount
    end
    contract_fixed_cost
  end

  def total_fixed_cost
    contract_fixed_cost + fixedCost
  end

  def contract_revenue
    contract_revenue = 0
    contracts_as_supplier.each do |c|
      contract_revenue += c.amount
    end
    contract_revenue
  end

  def total_revenue
    revenue + contract_revenue
  end

  def total_variable_cost
    if network
      return variableCost * network.operator.role.capacity
    else
      return 0
    end
  end

  def self.initialize_all_companies
    cs = Company.all
    cs.each do |c|
      c.revenue = 0
      c.calculate_costs
      c.profit = 0;
      c.save
    end
  end

  def notifications?
    contract_notifications? || rfp_notifications? || bid_notifications?
  end

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

  def rfp_notifications?
    received_rfps.each do |r|
      unless r.read
        return true
      end
    end
    return false
  end

  def bid_notifications?
    sent_rfp_bid_notifications? || received_rfp_bid_notifications?
  end

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

  def single_bid_notification?(bid)
   (!bid.read && bid.receiver == self && bid.waiting?) || (!bid.read && bid.sender == self && !bid.waiting?)
  end
  
  def notification_message_header
    if contract_notifications?
      return "Contract Proposal"
    elsif rfp_notifications?
      return "RFP Proposal"
    elsif bid_notifications? 
      return "BID Proposal"
    end
  end
  
  
  private
  def init_business_plan
    plan = self.create_business_plan
    for i in 0..4
      part = plan.plan_parts.create
      part.position = User.positions[i]
      part.save
    end
  end

  def calculate_fixed_cost(level, capacity, type, specialized)
    if is_operator?
      1000*type*capacity*level
    elsif is_customer_facing?
      1000
    elsif specialized
       (1000*level*capacity*type)/2
    else
     1000*capacity*type + 3000
    end
  end

  def calculate_variable_cost(level, capacity, type, specialized)
    if specialized
      (100*level*capacity*type)/2
    else
      (100*level*capacity*type)
    end
  end
    
  
end
# == Schema Information
#
# Table name: companies
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  fixedCost    :decimal(5, 2)   default(0.0)
#  variableCost :decimal(5, 2)   default(0.0)
#  revenue      :decimal(5, 2)   default(0.0)
#  profit       :decimal(5, 2)   default(0.0)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  group_id     :integer
#  service_type :string(255)
#  initialised  :boolean         default(FALSE)
#  about_us     :string(255)
#  assets       :decimal(5, 2)   default(0.0)
#  network_id   :integer
#

