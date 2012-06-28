class Company < ActiveRecord::Base
  
  after_create :init_business_plan
  
  attr_accessible :name, :group_id, :service_type, :size, :about_us, :operator_role_attributes, :customer_facing_role_attributes, :service_role_attributes
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
                  
  
  validates :name, presence: true, length: { maximum: 50 }
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
  
  def self.types
    ['Customer', 'Operator', 'Technology', 'Supplier']
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
    if self.network
      true
    else
      false
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

  
  
  private
  def init_business_plan
    plan = self.create_business_plan
    for i in 0..4
      part = plan.plan_parts.create
      part.position = User.positions[i]
      part.save
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

