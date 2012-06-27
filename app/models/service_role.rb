class ServiceRole < ActiveRecord::Base
  attr_accessible :service_level, :specialized, :service_type

  belongs_to :company

  validates :service_level, presence: true
  validates :service_type, presence: true
end
# == Schema Information
#
# Table name: service_roles
#
#  id            :integer         not null, primary key
#  service_level :integer
#  specialized   :boolean
#  service_type  :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  company_id    :integer
#

