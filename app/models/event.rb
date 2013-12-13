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
#

class Event < ActiveRecord::Base
  attr_accessible :company_id, :description, :title
  belongs_to :company
end
