=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

# == Schema Information
#
# Table name: rfps
#
#  id                  :integer          not null, primary key
#  sender_id           :integer
#  receiver_id         :integer
#  content             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  read                :boolean          default(FALSE)
#  contract_process_id :integer
#

#RFP, request for proposal, is a message sent to interesting companies.
#Bidding between companies cannot start until an RFP has been sent

class Rfp < ActiveRecord::Base
  attr_accessible :content, :receiver_id
  
  belongs_to :sender, class_name: "Company"
  belongs_to :receiver, class_name: "Company"
  
  #has_many :bids, :dependent => :destroy, :order => 'id ASC'
  
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  def latest_update
  if !self.bids.empty?
    self.bids.last.updated_at
  else
    self.updated_at
  end
end


  #Returns true if sender and target need to make a contract and both are available
  def self.valid_target?(sender, target)
    if sender.has_contract_with?(target)
      return false
    end
    return Rfp.rfp_target?(sender, target)
  end

 #Returns true if the sender and target need to make a contract to finish round 2
  def self.rfp_target?(sender, target)
    if sender.company_type.need?(target.company_type)
      return true
    end
    return false
  end

  #Returns true if the sender and target are valid and the sender has not yet sent an RFP to target company
  def self.can_send?(sender_user, target)
    sender_user.company && Rfp.valid_target?(sender_user.company, target) && (sender_user.company.values_decided? && target.values_decided?) && !Game.get_game.in_round(1) &&
      !Rfp.bid_waiting(sender_user.company, target)
  end

  def self.bid_waiting(sender, target)
    process = ContractProcess.find_by_parties(sender, target)
    return process && !process.bids.empty? &&  process.bids.last.waiting?
  end

end



