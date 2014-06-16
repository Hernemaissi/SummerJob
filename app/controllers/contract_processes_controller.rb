class ContractProcessesController < ApplicationController

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
end
