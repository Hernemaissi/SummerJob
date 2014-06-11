class ContractProcessesController < ApplicationController

  def update
    process = ContractProcess.find(params[:id])
    if process.update_attributes(:receiver_id => current_user.id)
      redirect_to company_mail_path(current_user.company, :anchor => "P")
    else
      flash[:error] = process.errors.full_messages.first
      redirect_to company_mail_path(current_user.company, :anchor => "P")
    end
    
  end
end
