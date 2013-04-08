# == Schema Information
#
# Table name: operator_roles
#
#  id            :integer          not null, primary key
#  service_level :integer
#  specialized   :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  company_id    :integer
#  capacity      :integer          default(1)
#  product_type  :integer          default(1)
#

#The Operator Role handles the actual implementation of the service or product
#It needs a contract with a customer facing company and different kinds of service companies

class OperatorRole < ActiveRecord::Base
  attr_accessible :service_level, :specialized, :capacity, :product_type

  belongs_to :company

  validates :service_level, presence: true
end
