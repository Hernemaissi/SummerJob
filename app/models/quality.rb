# == Schema Information
#
# Table name: qualities
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  used        :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Quality < ActiveRecord::Base
  attr_accessible :description, :title, :used, :qualityvalues_attributes, :amount
  has_many :qualityvalues, :dependent => :destroy

  attr_accessor :amount

  accepts_nested_attributes_for :qualityvalues, :reject_if => lambda { |a| a["value"].blank? }, :allow_destroy => true
end
