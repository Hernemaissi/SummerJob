class Market < ActiveRecord::Base
  attr_accessible :base_price, :customer_amount, :name, :preferred_level, :preferred_type, :price_buffer_integer
  has_many :customer_facing_roles
end
# == Schema Information
#
# Table name: markets
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  customer_amount :integer
#  preferred_type  :integer
#  preferred_level :integer
#  base_price      :integer
#  price_buffer    :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

