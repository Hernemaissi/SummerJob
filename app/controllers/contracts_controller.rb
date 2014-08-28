class ContractsController < ApplicationController
  before_filter :allowed_to_see
  before_filter :can_decide, only: [:decide]
  
  def show
    @contract = Contract.find(params[:id])
    @decision_seen = (current_user.company && current_user.company == @contract.negotiation_sender) ? @contract.update_seen : true
  end

  def update
    @contract = Contract.find(params[:id])
    @contract.under_negotiation = true
    @contract.negotiation_sender_id = current_user.company.id
    if params[:type] == Contract.renegotiation
      @contract.update_attributes(params[:contract])
      @contract.negotiation_type = Contract.renegotiation
    else
      @contract.negotiation_type = Contract.end_contract
      @contract.save(validate: false)
        flash[:success] = "Sent request to end contract"
        Event.create_event("Dissolving contract requested", 4, Hash["company_name" => @contract.negotiation_sender.name], @contract.negotiation_receiver.id)
        redirect_to @contract and return
    end
    if @contract.save
      Event.create_event("Re-negotiation requested", 5, Hash["company_name" => @contract.negotiation_sender.name], @contract.negotiation_receiver.id)
      flash[:success] =  "Sent re-negotation request"
      redirect_to @contract
    else
      @contract.under_negotiation = false
      @contract.negotiation_sender_id = nil
      @contract.negotiation_type = nil
      render 'show'
    end
  end

  def decision
    @contract = Contract.find(params[:id])
    @contract.decision_seen = false
    @contract.last_decision = params[:decision]
    if params[:decision] == "ACC"
      if @contract.negotiation_type == Contract.renegotiation
        @contract.bid.amount = @contract.new_amount
        @contract.bid.agreed_duration = @contract.new_duration
        @contract.bid.remaining_duration = @contract.new_duration
        @contract.update_amount(@contract.new_launches)
        @contract.bid.offer = @contract.bid.create_offer
        if @contract.bid.save
          @contract.under_negotiation = false
          @contract.save!
          Event.create_event("Contract renogotiated", 6, Hash["company_name" => @contract.service_buyer.name], @contract.service_provider.id)
          Event.create_event("Contract renogotiated", 6, Hash["company_name" => @contract.service_provider.name], @contract.service_buyer.id)
          flash[:success] = "Contract re-negotiated"
          redirect_to @contract
        else
          flash[:error] = "Cannot re-negotiate with these terms"
          redirect_to @contract
        end
      else
        @contract.bid.update_attribute(:status, Bid.rejected)
        @contract.update_attribute(:void, true)
        Event.create_event("Contract dissolved", 7, Hash["company_name" => @contract.service_buyer.name],  @contract.service_provider.id)
        Event.create_event("Contract dissolved", 7, Hash["company_name" => @contract.service_provider.name], @contract.service_buyer.id)
        flash[:success] = "Contract has ended"
        redirect_to current_user.company
      end
      
    else
      @contract.under_negotiation = false
      if @contract.negotiation_type == Contract.renegotiation
        Event.create_event("Proposal declined", 8, Hash["company_name" => current_user.company.name],  @contract.other_party(current_user.company).id)
      else
        Event.create_event("Proposal declined", 9,  Hash["company_name" => current_user.company.name], @contract.other_party(current_user.company).id)
      end
      @contract.save!
      redirect_to @contract
    end
  end

  def destroy
    c = Contract.find(params[:id])
    c.bid.update_attribute(:status, Bid.rejected)
    c.bid.update_attribute(:broken, true)
    current_user.company.update_attribute(:break_cost, current_user.company.break_cost + c.bid.penalty)
    c.warning_email(current_user)
    Event.create_event("Contract broken",10, Hash["company_name" => c.other_party(current_user.company).name],  current_user.company.id)
    Event.create_event("Contract broken", 11,  Hash["company_name" => current_user.company.name], c.other_party(current_user.company).id)
    @contract.update_attribute(:void, true)
    redirect_to current_user.company
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
