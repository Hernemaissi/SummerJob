class ContractsController < ApplicationController
  before_filter :allowed_to_see
  
  def show
    @contract = Contract.find(params[:id])
  end
  
  private
  
  def allowed_to_see
    @contract = Contract.find(params[:id])
    unless signed_in? && (current_user.isOwner?(@contract.service_provider) || current_user.isOwner?(@contract.service_buyer))
      flash[:error] = "You are not allowed to view this page"
      redirect_to root_path
    end
  end
end
