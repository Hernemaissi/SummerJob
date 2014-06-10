class ContractProcessesController < ApplicationController

  def update
    process = ContractProcess.find(params[:id])
    process.update_attribute(:receiver_id, current_user.id)
    redirect_to company_mail_path(current_user.company)
  end
end
