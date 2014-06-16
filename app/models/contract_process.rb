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

  validate :validate_initiator
  validate :validate_receiver, :on => :update

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
    if first_party.has_contract_with?(second_party)
      c = first_party.get_contract_with(second_party)
      return nil if !c.under_negotiation
      return c.negotiation_receiver
    end
    next_to_act = nil
    next_item = self.rfps.last.bids.last
    return nil if next_item && next_item.rejected?
    next_item = self.rfps.last if !next_item
    next_to_act = next_item.receiver
    return next_to_act
  end

  def next_action
    if first_party.has_contract_with?(second_party)
      contract = first_party.get_contract_with(second_party)
      return 0 if contract.under_negotiation
      return 1
    end
    bid = self.rfps.last.bids.last
    if bid
      return 2 if bid.waiting?
      return 3
    end
    return 4
  end

  def status_to_string(status)

    case status
    when 0
      return "Contract renegotiation"
    when 1
      return "Contract is formed"
    when 2
      return "Waiting for an answer to bid"
    when 3
      return "Latest bid rejected"
    when 4
      return "Waiting for bids"
    else
      return "Unkown status"
    end

  end

  def send_bid?(user)
    act = next_action
    if act == 3 || (act == 4 && user == receiver)
      return true
    end
    return false
  end

  def show_bid?(user)
    act = next_action
    if act == 2
      bid = self.rfps.last.bids.last
      return user.company == bid.receiver
    end
    return false
  end

  def show_contract?(user)
    if first_party.has_contract_with?(second_party)
      contract = first_party.get_contract_with(second_party)
      return contract.under_negotiation && user.company == contract.negotiation_receiver && (user == receiver || user == initiator)
    end
    return false
  end

  def other_party(party)
    return (party == first_party) ? second_party : first_party
  end

  def resp_user(party)
    return initiator if  initiator && initiator.isOwner?(party)
    return receiver if receiver && receiver.isOwner?(party)
  end

  def validate_initiator
    if self.initiator &&  self.initiator_id_changed? && !self.initiator.can_take_process?
         errors.add(:base, "You are already handling more processes than you groupmates. One of them must take the process")
    end
  end

  def validate_receiver
    if self.receiver && self.receiver_id_changed? && !self.receiver.can_take_process?
         errors.add(:base, "You are already handling more processes than you groupmates. One of them must take the process")
    end
  end

end
