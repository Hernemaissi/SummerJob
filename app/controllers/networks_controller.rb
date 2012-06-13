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
  
  def show_companies
    @network = Network.find(params[:id])
    @companies = Company.all
  end

  def add_company
    company = Company.find(params[:company_id])
    company.update_attribute(:network_id, params[:id])
    redirect_to show_companies_path(params[:id])
  end
  
  def remove_company
    company = Company.find(params[:company_id])
    company.update_attribute(:network_id, nil)
    @network = Network.find(params[:id])
    redirect_to @network
  end
  
end
