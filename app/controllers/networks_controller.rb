class NetworksController < ApplicationController
   before_filter :teacher_user, only: [:index, :network_quick_view]
   before_filter :belongs_to_network, only: [:show, :results, :news]
   before_filter :results_published, only: [:results, :news]
  
  def index
    @networks = Network.all
  end

  def show
    @network = Network.find(params[:id])
  end

  def results
    @markets = Market.all
    @networks = Network.order("score DESC")
    @companies = Company.all
    @ranked_operators = Company.where(:service_type => Company.types[1]).order("total_profit DESC").limit(3)
    @ranked_customers = Company.where(:service_type => Company.types[0]).order("total_profit DESC").limit(3)
    @ranked_tech = Company.where(:service_type => Company.types[2]).order("total_profit DESC").limit(3)
    @ranked_supplies = Company.where(:service_type => Company.types[3]).order("total_profit DESC").limit(3)
  end

  def news
    @markets = Market.all
    @companies = Company.all
    @ranked_operators = Company.where(:service_type => Company.types[1]).order("total_profit DESC").limit(3)
    @ranked_customers = Company.where(:service_type => Company.types[0]).order("total_profit DESC").limit(3)
    @ranked_tech = Company.where(:service_type => Company.types[2]).order("total_profit DESC").limit(3)
    @ranked_supplies = Company.where(:service_type => Company.types[3]).order("total_profit DESC").limit(3)
  end

  def quick_view
    @networks = Network.all
  end

  private

  def belongs_to_network
    @network = Network.find(params[:id])
    unless current_user.teacher?
      unless current_user.company && current_user.company.network == @network
        redirect_to root_path
      end
      @company = current_user.company
    end
  end

  def results_published
    unless @game.results_published || current_user.teacher?
      flash[:error] = "Results are not yet published for this round"
      redirect_to root_path
    end
  end
  
end
