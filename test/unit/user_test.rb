# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  student_number         :string(255)
#  department             :string(255)
#  teacher                :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  group_id               :integer
#  position               :string(255)
#  description            :text
#  registration_token     :string(255)
#  registered             :boolean          default(FALSE)
#  group_token            :string(255)
#  group_registered       :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
