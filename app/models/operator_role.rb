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
# Table name: operator_roles
#
#  id            :integer          not null, primary key
#  service_level :integer
#  specialized   :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  company_id    :integer
#  capacity      :integer          default(1)
#  product_type  :integer
#

#The Operator Role handles the actual implementation of the service or product
#It needs a contract with a customer facing company and different kinds of service companies

class OperatorRole < ActiveRecord::Base
  attr_accessible :service_level, :specialized, :capacity, :product_type

  belongs_to :company


end
