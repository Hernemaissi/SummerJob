class NetworksController < ApplicationController
   before_filter :teacher_user, only: [:index]
   before_filter :belongs_to_network, only: [:show]
  
  def index
    @networks = Network.all
  end

  def show
    @network = Network.find(params[:id])
  end

  private

  def belongs_to_network
    @network = Network.find(params[:id])
    unless current_user.isTeacher?
      unless current_user.company && current_user.company.network == @network
        redirect_to root_path
      end
    end
  end
  
end
