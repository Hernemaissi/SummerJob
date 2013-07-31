# == Schema Information
#
# Table name: news
#
#  id             :integer          not null, primary key
#  headline       :string(255)
#  picture_url    :string(255)
#  content        :text
#  market_content :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  risk_content   :text
#

require 'test_helper'

class NewsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
