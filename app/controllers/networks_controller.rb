class NetworksController < ApplicationController
   before_filter :teacher_user
  
  def index
    @networks = Network.all
  end

  def show
    @network = Network.find(params[:id])
  end

  def new
    @network = Network.new
  end
  
  def create
    @network = Network.create()
    if @network.save
      flash[:success] = "Succesfully created new network"
      redirect_to @network
    else
      flash.now[:error] = "Error creating a network, please contact admin"
      render 'new'
    end
  end
end
