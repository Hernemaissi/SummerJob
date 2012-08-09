class Risk < ActiveRecord::Base

  attr_accessible :customer_return, :description, :penalty, :possibility, :title, :severity

  has_many :companies

  validates :title, presence: true
  validates :description, :presence => true
  validates :penalty, :presence => true, :numericality => true
  validates :customer_return, :presence => true, :numericality => { :greater_than_or_equal_to  => 0, :less_than_or_equal_to => 100 }
  validates :possibility,  :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :severity, :presence => true, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }
  
end
# == Schema Information
#
# Table name: risks
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :text
#  customer_return :integer
#  penalty         :integer
#  possibility     :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  severity        :integer         default(1)
#

