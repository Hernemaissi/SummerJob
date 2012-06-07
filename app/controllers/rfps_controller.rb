class RfpsController < ApplicationController
  before_filter :has_company
  
  def new
    @rfp = Rfp.new
    @target_company = Company.find(params[:id])
    @rfp.receiver_id = @target_company.id
  end

  def create
    content = params[:rfp][:content]
    target_company = Company.find(params[:rfp][:receiver_id])
    current_user.group.company.send_rfp!(target_company, content)
    redirect_to current_user.group.company
  end

  def show
    @rfp = Rfp.find(params[:id])
  end
  
  private
  
  
end
