# == Schema Information
#
# Table name: company_types
#
#  id                 :integer          not null, primary key
#  capacity_need      :boolean
#  capacity_produce   :boolean
#  experience_need    :boolean
#  experience_produce :boolean
#  unit_need          :boolean
#  unit_produce       :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  name               :string(255)
#  marketing_need     :boolean
#  marketing_produce  :boolean
#  limit_hash         :text
#  price_set          :boolean
#  image              :string(255)
#  capital_bonus      :text
#

require 'test_helper'

class CompanyTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
