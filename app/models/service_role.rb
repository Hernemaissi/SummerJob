# == Schema Information
#
# Table name: service_roles
#
#  id            :integer          not null, primary key
#  service_level :integer
#  specialized   :boolean
#  service_type  :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  company_id    :integer
#  product_type  :integer
#

#Service companies provide service to the operators

class ServiceRole < ActiveRecord::Base
  attr_accessible :service_level, :specialized, :service_type, :product_type

  belongs_to :company

  validates :service_level, presence: true
  validates :service_type, presence: true

  #Checks if the company has a contract with an operator
 def has_contract?
   company.has_contract_with_type?("Operator")
 end

end
