# == Schema Information
#
# Table name: risks
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  description     :text
#  customer_return :integer
#  penalty         :integer
#  possibility     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  severity        :integer          default(1)
#

class Risk < ActiveRecord::Base

  attr_accessible :customer_return, :description, :penalty, :possibility, :title, :severity

  has_many :customer_facing_roles
  has_many :markets

  validates :title, presence: true
  validates :description, :presence => true
  validates :penalty, :presence => true, :numericality => true
  validates :customer_return, :presence => true, :numericality => { :greater_than_or_equal_to  => 0, :less_than_or_equal_to => 100 }
  validates :possibility,  :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :severity, :presence => true, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }


  def self.apply_risks
    companies = CustomerFacingRole.all
    companies.each do |c|
      risk_mit = Network.get_risk_mitigation(c)
      happening = 0
      Risk.all.each do |r|
        chance = r.possibility - risk_mit
        chance = (chance > 0) ? chance : 1            #There is always at least 1% chance for a accident to happen, no matter how much risk control is used
        happening = Random.rand(0..100)
        if happening <= chance
          c.risk = r if (c.risk == nil || c.risk.severity < r.severity)
        end
      end
      c.save!
    end
  end


  
end
