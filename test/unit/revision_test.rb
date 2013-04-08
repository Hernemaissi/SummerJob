# == Schema Information
#
# Table name: revisions
#
#  id                     :integer          not null, primary key
#  company_id             :integer
#  value_proposition      :text
#  revenue_streams        :text
#  cost_structure         :text
#  key_resources          :text
#  key_activities         :text
#  customer_segments      :text
#  key_partners           :text
#  channels               :text
#  customer_relationships :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  reasoning              :text
#

require 'test_helper'

class RevisionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
