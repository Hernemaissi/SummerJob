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

  def read_bids
    process = ContractProcess.find(params[:id])
    process.bids.each do |b|
      b.update_attribute(:read, true) if b.unread?(current_user.company)
    end
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end


  def validate_claimer
    process = ContractProcess.find(params[:id])
    update_receiver = params[:receiver] == "1"

    if update_receiver && !current_user.isOwner?(process.second_party)
      redirect_to company_mail_path(current_user.company, :anchor => "P"), :status => 403
    elsif !update_receiver && !current_user.isOwner?(process.first_party)
      render :nothing => true, :status => 403
      redirect_to company_mail_path(current_user.company, :anchor => "P"), :status => 403
    end

  end

end
