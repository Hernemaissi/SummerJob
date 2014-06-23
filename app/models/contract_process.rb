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

  belongs_to :initiator, class_name: "User"       #RENAME as buyer_rep
  belongs_to :receiver, class_name: "User"      #RENAME as seller_rep
  belongs_to :first_party, class_name: "Company"
  belongs_to :second_party, class_name: "Company"
  has_many :rfps, :dependent => :destroy
  has_many :bids, :dependent => :destroy

  validate :validate_initiator
  validate :validate_receiver, :on => :update

  def self.find_or_create_from_rfp(target_company,  initiator_user)
    current_company = initiator_user.company
    process = nil
    ContractProcess.all.each do |c|
      process = c if (target_company == c.first_party || target_company == c.second_party) && (current_company == c.first_party || current_company == c.second_party)
    end
    process = ContractProcess.create(:initiator_id => initiator_user.id, :first_party_id => current_company.id, :second_party_id => target_company.id) if !process
    return process
  end

  def self.find_or_create_from_offer(target_company,  user)
    current_company = user.company
    process = nil
    ContractProcess.all.each do |c|
      process = c if (target_company == c.first_party || target_company == c.second_party) && (current_company == c.first_party || current_company == c.second_party)
    end
    process = ContractProcess.create(:receiver_id => user.id, :first_party_id => target_company.id, :second_party_id => current_company.id) if !process
    return process
  end

  def self.find_by_parties(first_company, second_company)
    ContractProcess.all.each do |p|
      return p if (first_company == p.first_party || first_company == p.second_party) && (second_company == p.first_party || second_company == p.second_party)
    end
    return nil
  end

  def next_action_by
    if first_party.has_contract_with?(second_party)
      c = first_party.get_contract_with(second_party)
      return nil if !c.under_negotiation
      return c.negotiation_receiver
    end
    next_to_act = nil
    next_item = nil
    next_bid = self.bids.last
    next_rfp = self.rfps.last
     if (next_rfp && !next_bid) || (next_rfp && next_bid && next_rfp.created_at > next_bid.created_at)
       next_item = next_rfp
       next_to_act = next_item.receiver
     else
       next_to_act =  next_bid.waiting? ? next_bid.receiver : next_bid.sender
     end
    return next_to_act
  end

  def next_action
    if first_party.has_contract_with?(second_party)
      contract = first_party.get_contract_with(second_party)
      return 0 if contract.under_negotiation
      return 1
    end
    item = self.items.last
    if item.kind_of? Bid
      return 2 if item.waiting?
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
    return (act == 3 || act == 4) && Bid.can_offer?(user, self.other_party(user.company))
  end

  def send_rfp?(user)
    act = next_action
    return (act == 3 || act == 4) && Rfp.can_send?(user, self.other_party(user.company))
  end

  def show_bid?(user)
    act = next_action
    if act == 2
      bid = self.bids.last
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

  def items
    items = self.rfps.all.concat(self.bids.all)
    return items.sort_by{|e| e.created_at}
  end

  def other_party(party)
    return (party == first_party) ? second_party : first_party
  end

  def resp_user(party)
    return initiator if  initiator && initiator.isOwner?(party)
    return receiver if receiver && receiver.isOwner?(party)
  end

  def resp_user?(user)
    return user == initiator || user == receiver
  end

  def self.can_act?(user, target_company)
    p = ContractProcess.find_by_parties(user.company, target_company)
    return (p && p.resp_user?(user)) || !p
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
