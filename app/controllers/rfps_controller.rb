class RfpsController < ApplicationController
  before_filter :has_company
  before_filter :is_allowed_to_see, only: [:show]
  before_filter :in_round_two, only: [:new, :create]
  before_filter :can_send?, only: [:new, :create]
  
  def new
    @rfp = Rfp.new
    @target_company = Company.find(params[:id])
    if !Rfp.can_send?(current_user.company, @target_company)
      flash[:error] = "You do not need this company to operate so there is no need to send a RFP"
      redirect_to @target_company
    end
    @rfp.receiver_id = @target_company.id
  end

  def create
    content = params[:rfp][:content]
    target_company = Company.find(params[:rfp][:receiver_id])
    current_user.group.company.send_rfp!(target_company, content)
    redirect_to current_user.group.company
  end

  def show
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
    unless Rfp.can_send?(current_user.company, @target_company)
      flash[:error] = "You cannot send an RFP to this company"
      redirect_to @target_company
    end
  end
  
end
