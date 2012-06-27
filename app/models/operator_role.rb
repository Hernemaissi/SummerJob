class OperatorRole < ActiveRecord::Base
  attr_accessible :service_level, :specialized

  belongs_to :company

  validates :service_level, presence: true
end
# == Schema Information
#
# Table name: operator_roles
#
#  id            :integer         not null, primary key
#  service_level :integer
#  specialized   :boolean
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  company_id    :integer
#

