class Revision < ActiveRecord::Base
  attr_accessible :channels, :company_id, :cost_structure, :customer_relationships, :customer_segments, :key_activities, :key_partners, :key_resources, :revenue_streams, :value_proposition

  belongs_to :company
end
# == Schema Information
#
# Table name: revisions
#
#  id                     :integer         not null, primary key
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
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

