class NetworksController < ApplicationController
   before_filter :teacher_user, only: [:index]
   before_filter :belongs_to_network, only: [:show, :results]
  
  def index
    @networks = Network.all
  end

  def show
    @network = Network.find(params[:id])
  end

  def results
    @markets = Market.all
  end

  private

  def belongs_to_network
    @network = Network.find(params[:id])
    unless current_user.isTeacher?
      unless current_user.company && current_user.company.network == @network
        redirect_to root_path
      end
      @company = current_user.company
    end
  end
  
end
