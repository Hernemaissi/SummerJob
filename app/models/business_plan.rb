class BusinessPlan < ActiveRecord::Base
  attr_accessible :public
end
# == Schema Information
#
# Table name: business_plans
#
#  id         :integer         not null, primary key
#  public     :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

