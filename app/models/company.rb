class Company < ActiveRecord::Base
  
  after_create :init_business_plan
  
  attr_accessible :name, :group_id, :service_type, :size, :about_us
  belongs_to :group
  has_one :business_plan
  
  has_many :needs, foreign_key: "needer_id", dependent: :destroy
  has_many :needed_companies, through: :needs, source: :needed
  has_many :reverse_needs, foreign_key: "needed_id",
                           class_name: "Need",
                           dependent: :destroy
                          
  has_many :needers, through: :reverse_needs, source: :needer
  
  has_many :sent_rfps, foreign_key: "sender_id",
                           class_name: "Rfp",
                           dependent: :destroy
  has_many :received_rfps, foreign_key: "receiver_id",
                           class_name: "Rfp",
                           dependent: :destroy
                  
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :group_id, presence: true
  validates :fixedCost, presence: true
  validates :variableCost, presence: true
  validates :revenue, presence: true
  validates :profit, presence: true
  
  def self.types
    ['Customer', 'Marketing', 'Technology', 'Supplier']
  end
  
  def send_rfp!(other_company, content)
    sent_rfps.create!(receiver_id: other_company.id, content: content)
  end
  
  def has_sent_rfp?(other_company)
    sent_rfps.find_by_receiver_id(other_company.id)
  end
  
  def needs?(other_company)
    needs.find_by_needed_id(other_company.id)
  end

  def need!(other_company)
    needs.create!(needed_id: other_company.id)
  end
  
  def remove_need!(other_company)
    needs.find_by_needed_id(other_company.id).destroy
  end
  
  def type_to_s
    if self.service_type == "Marketing"
      "customer penetration"
    elsif self.service_type == "Technology"
      "quality"
    elsif self.service_type == "Supplier"
      "capacity"
    else
      "unknown"
    end
  end
  
  def get_max_service
    if self.service_type == "Marketing"
      self.max_penetration
    elsif self.service_type == "Technology"
      self.max_quality
    elsif self.service_type == "Supplier"
      self.max_capacity
    else
      0
    end
  end
  
  private
  def init_business_plan
    plan = self.create_business_plan
    size = self.group.users.count
    i = 0;
    while i < size do
      plan.plan_parts.create
      i+= 1
    end
  end
    
  
end
# == Schema Information
#
# Table name: companies
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  fixedCost       :decimal(5, 2)   default(0.0)
#  variableCost    :decimal(5, 2)   default(0.0)
#  revenue         :decimal(5, 2)   default(0.0)
#  profit          :decimal(5, 2)   default(0.0)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  group_id        :integer
#  max_capacity    :integer
#  capacity        :integer         default(0)
#  max_quality     :integer
#  quality         :integer         default(0)
#  penetration     :integer         default(0)
#  max_penetration :integer
#  service_type    :string(255)
#  initialised     :boolean         default(FALSE)
#  about_us        :string(255)
#  size            :integer
#

