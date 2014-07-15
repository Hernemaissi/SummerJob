# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  read        :boolean          default(FALSE)
#  code        :integer
#  data_hash   :text
#

class Event < ActiveRecord::Base
  attr_accessible :company_id, :description, :title, :event, :data_hash, :code
  belongs_to :company

  serialize :data_hash, Hash

  def code_to_message
    case self.code
    when 0
      I18n.t :ev_contract_formed, company_name: data_hash["company_name"]
    when 1
      I18n.t :ev_rfp_sent, company_name: data_hash["company_name"]
    when 2
      I18n.t :ev_rfp_received, company_name: data_hash["company_name"]
    when 3
      I18n.t :ev_bid_received, company_name: data_hash["company_name"]
    when 4
      I18n.t :ev_void_request, company_name: data_hash["company_name"]
    when 5
      I18n.t :ev_renegotiation_request, company_name: data_hash["company_name"]
    when 6
      I18n.t :ev_contract_renegotiated, company_name: data_hash["company_name"]
    when 7
      I18n.t :ev_contract_voided, company_name: data_hash["company_name"]
    when 8
      I18n.t :ev_renegotiation_declined, company_name: data_hash["company_name"]
    when 9
      I18n.t :ev_void_declined, company_name: data_hash["company_name"]
    when 10
      I18n.t :ev_contract_broken_first, company_name: data_hash["company_name"]
    when 11
      I18n.t :ev_contract_broken_second, company_name: data_hash["company_name"]
    when 12
      I18n.t :ev_bid_sent, company_name: data_hash["company_name"]
    else
      "No message"
    end
  end
end
