class Risk < ActiveRecord::Base

  attr_accessible :customer_return, :description, :penalty, :possibility, :title, :severity

  has_many :networks

  validates :title, presence: true
  validates :description, :presence => true
  validates :penalty, :presence => true, :numericality => true
  validates :customer_return, :presence => true, :numericality => { :greater_than_or_equal_to  => 0, :less_than_or_equal_to => 100 }
  validates :possibility,  :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :severity, :presence => true, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }

  #This method will loop through all networks and randomize if a risk happens to a network
  def self.apply_risks
    nets = Network.all
    nets.each do |n|
      n.get_risk_mitigation
      n.risk_id = nil
      Risk.all.each do |r|
        risk_chance = r.possibility - n.risk_mitigation
        if (n.id == 6)
          puts "Risk chance for network 6 is #{risk_chance}"
        end
        risk_chance = 1 if risk_chance <= 0
        random = rand(101)
        puts "Random is #{random}"
        if random <= risk_chance && (n.risk == nil || n.risk.severity < r.severity)
          n.risk = r
        end
      end
      if n.risk != nil
        customer_facing = n.customer_facing
        customer_facing.revenue -= ((n.risk.customer_return.to_f / 100) * customer_facing.revenue)
        customer_facing.revenue -= n.risk.penalty
        customer_facing.save!
      end
      n.save!
    end
  end
  
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

