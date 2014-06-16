class ContractProcessesController < ApplicationController
  before_filter :validate_claimer, only: [:update]

  def update
    process = ContractProcess.find(params[:id])
    update_receiver = params[:receiver] == "1"
    saved = (update_receiver) ? process.update_attributes(:receiver_id => current_user.id) : process.update_attributes(:initiator_id => current_user.id)
    if saved
      redirect_to company_mail_path(current_user.company, :anchor => "P")
    else
      flash[:error] = process.errors.full_messages.first
      redirect_to company_mail_path(current_user.company, :anchor => "P")
    end
    
  end


  def validate_claimer
    process = ContractProcess.find(params[:id])
    update_receiver = params[:receiver] == "1"

    if update_receiver && !current_user.isOwner?(process.second_party)
      redirect_to company_mail_path(current_user.company, :anchor => "P")
    elsif !update_receiver && !current_user.isOwner?(process.first_party)
      redirect_to company_mail_path(current_user.company, :anchor => "P")
    end

  end

end
