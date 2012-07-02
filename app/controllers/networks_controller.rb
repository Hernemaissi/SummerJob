class NetworksController < ApplicationController
   before_filter :teacher_user
  
  def index
    @networks = Network.all
  end

  def show
    @network = Network.find(params[:id])
  end
  
end
