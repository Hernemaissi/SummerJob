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

  validates :service_type, presence: true

  #Checks if the company has a contract with an operator
 def has_contract?
   company.has_contract_with_type?("Operator")
 end

end
