class ContractsController < ApplicationController
  before_filter :allowed_to_see
  before_filter :can_decide, only: [:decide]
  
  def show
    @contract = Contract.find(params[:id])
  end

  def update
    @contract = Contract.find(params[:id])
    @contract.update_attributes(params[:contract])
    @contract.under_negotiation = true
    @contract.negotiation_sender_id = current_user.company.id
    if @contract.save
      flash[:success] = "Sent re-negotation request"
      redirect_to @contract
    else
      @contract.under_negotiation = false
      render 'show'
    end
  end

  def decision
    @contract = Contract.find(params[:id])
    if params[:decision] == "ACC"
      @contract.bid.amount = @contract.new_amount
      @contract.bid.offer = @contract.bid.create_offer
      if @contract.bid.save
        @contract.under_negotiation = false
        @contract.save!
        flash[:success] = "Contract re-negotiated"
        redirect_to @contract
      else
        flash[:error] = "Cannot re-negotiate with these terms"
        redirect_to @contract
      end
    else
      @contract.under_negotiation = false
      @contract.save!
      redirect_to @contract
    end
  end
  
  private
  
  def allowed_to_see
    @contract = Contract.find(params[:id])
    unless signed_in? && (current_user.isOwner?(@contract.service_provider) || current_user.isOwner?(@contract.service_buyer))
      flash[:error] = "You are not allowed to view this page"
      redirect_to root_path
    end
  end

  def can_decide
     @contract = Contract.find(params[:id])
     unless current_user.company == @contract.negotiation_receiver
       redirect_to root_path
     end
  end
end
