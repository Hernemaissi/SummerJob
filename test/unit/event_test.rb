# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  read        :boolean          default(FALSE)
#  code        :integer
#  data_hash   :text
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
