class NetworksController < ApplicationController
   before_filter :teacher_user, only: [:index, :network_quick_view]
   before_filter :redirect_if_not_own, only: [ :results]
   before_filter :results_published, only: [:results, :news]
  
  def index
    @customer_facing_companies = Company.where("service_type = ?", Company.types[0])
  end

  def show
    @company = Company.find(params[:id])
    @network_chunk = @company.get_network_chunked
  end

  def results
    @company = Company.find(params[:id])
    @customer_facing_companies = @company.get_customer_facing_company
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

  def redirect_if_not_own
    unless current_user.teacher?
      puts "Params id : #{params[:id]}"
      puts "Company id: #{current_user.company.id}"
      puts "Truth: #{params[:id] != current_user.company.id.to_s}"
      puts "path: #{request.path}"
      if params[:id] != current_user.company.id.to_s
        new_path = request.path.gsub(/\d+/, current_user.company.id.to_s)
        redirect_to new_path
      end
    end
  end

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
