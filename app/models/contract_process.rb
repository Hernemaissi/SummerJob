# == Schema Information
#
# Table name: contract_processes
#
#  id              :integer          not null, primary key
#  initiator_id    :integer
#  receiver_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  first_party_id  :integer
#  second_party_id :integer
#

class ContractProcess < ActiveRecord::Base
  attr_accessible :initiator_id, :receiver_id, :first_party_id, :second_party_id

  belongs_to :initiator, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :first_party, class_name: "Company"
  belongs_to :second_party, class_name: "Company"
  has_many :rfps


  def self.find_or_create(target_company,  initiator_user)
    current_company = initiator_user.company
    process = nil
    ContractProcess.all.each do |c|
      process = c if (target_company == c.first_party || target_company == c.second_party) && (current_company == c.first_party || current_company == c.second_party)
    end
    process = ContractProcess.create(:initiator_id => initiator_user.id, :first_party_id => current_company.id, :second_party_id => target_company.id) if !process
    return process
  end

  def next_action_by
    return nil if first_party.has_contract_with?(second_party)
    next_to_act = nil
    next_item = self.rfps.last.bids.last
    next_item = self.rfps.last if !next_item
    next_to_act = next_item.receiver
    return next_to_act
  end

  def next_action
    if first_party.has_contract_with?(second_party)
      contract = first_party.get_contract_with(second_party)
      return "Contract renegotiation" if contract.under_negotiation
      return "No action needed"
    end
    bid = self.rfps.last.bids.last
    if bid
      return "Waiting for an answer to bid" if bid.waiting?
      return "Latest bid rejected"
    end
    return "Waiting for bids"
  end

  def other_party(party)
    return (party == first_party) ? second_party : first_party
  end

  def resp_user(party)
    return initiator if initiator.isOwner?(party)
    return receiver if receiver && receiver.isOwner?(party)
  end

end
