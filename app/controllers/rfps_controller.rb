class RfpsController < ApplicationController
  before_filter :has_company
  before_filter :is_allowed_to_see, only: [:show]
  before_filter :not_in_round_one, only: [:new, :create]
  before_filter :can_send?, only: [:new, :create]
  
  def new
    @rfp = Rfp.new
    @target_company = Company.find(params[:id])
    if !Rfp.valid_target?(current_user.company, @target_company)
      flash[:error] = "You do not need this company to operate so there is no need to send a RFP"
      redirect_to @target_company
    end
    @rfp.receiver_id = @target_company.id
  end

  def create
    content = params[:rfp][:content]
    target_company = Company.find(params[:rfp][:receiver_id])
    process = ContractProcess.find_or_create_from_rfp(target_company, current_user)
    if !process.valid?
      flash.now[:error] = process.errors.full_messages.first
      @rfp = Rfp.new
      @target_company = target_company
      @rfp.receiver_id = @target_company.id
      render 'new'
    else
      rfp = current_user.group.company.send_rfp!(target_company, content)
      flash[:success] = "RFP sent to to #{target_company.name}"
      Event.create(:title => "RFP sent", :description => "You have send an RFP to #{target_company.name}", :company_id => current_user.company.id)
      Event.create(:title => "RFP received", :description => "You have received an RFP from #{current_user.company.name}", :company_id => target_company.id)
      rfp.update_attribute(:contract_process_id, process.id)
      redirect_to current_user.group.company
    end

    
  end

  def show
    unless @rfp.read
      if @rfp.receiver == current_user.company
        @rfp.read = true
        @rfp.save(validate: false)
      end
    end
  end

  def update
    rfp = Rfp.find(params[:id])
    rfp.mark_all_bids
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
  
  private
  
  def is_allowed_to_see
    @rfp = Rfp.find(params[:id])
    unless signed_in? && (current_user.isOwner?(@rfp.sender) || current_user.isOwner?(@rfp.receiver))
      flash[:error] = "You are not allowed to view this item"
      redirect_to root_path
    end
  end

  def  can_send?
    if params[:id]
      @target_company = Company.find(params[:id])
    else
      @target_company = Company.find(params[:rfp][:receiver_id])
    end
    unless Rfp.can_send?(current_user, @target_company)
      flash[:error] = "You cannot send an RFP to this company"
      redirect_to @target_company
    end
  end
  
end
