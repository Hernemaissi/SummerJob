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
#  grade                  :integer
#  feedback               :text
#  read                   :boolean          default(TRUE)
#

class Revision < ActiveRecord::Base
  attr_accessible :channels, :company_id, :cost_structure, :customer_relationships, :customer_segments, :key_activities, :key_partners, :key_resources, :revenue_streams, :value_proposition, :grade, :feedback

  belongs_to :company

  def self.grades
    [0, 1, 2, 3, 4, 5]
  end

end
