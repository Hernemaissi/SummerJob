class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include CompaniesHelper
  before_filter :find_game
  before_filter :still_calculating
  before_filter :finished
  before_filter :registered
  
  protected
    
    def teacher_user
      redirect_to(root_path) unless  signed_in? && current_user.teacher?
    end
    
    def signed_in_user
      store_location unless signed_in?
      redirect_to signin_path, notice: "Please sign in." unless signed_in?
    end
    
    def company_owner
      @company = Company.find(params[:id])
      if !signed_in? || !current_user.group || !current_user.group.company || !(current_user.group.company.id == @company.id)
        unless signed_in? && current_user.teacher?
          flash[:error] = "You are not allowed to view this page"
          redirect_to(root_path)
        end
      end
    end
    
    def has_company
      if (!signed_in? || !current_user.group || !current_user.group.company) && !(signed_in? && current_user.teacher?)
        flash[:error] = "You cannot visit these pages until you are assigned into a company"
        redirect_to(root_path)
      end
    end
    
    def find_game
      @game = Game.first
      if !@game
        @game = Game.create
        @game.save
      end
    end

    def still_calculating
      if @game.calculating && (!signed_in? || !current_user.teacher)
        redirect_to busy_path
      end
    end

    def finished
      if @game.finished
        redirect_to results_path
      end
    end

    def registered
      if signed_in? && (!current_user.teacher && !current_user.registered)
        flash[:notice] = "You have not completed registration. Please follow the instructions sent to you by email. If you have not received the email, please contact an admin"
        redirect_to current_user
      end
    end
    
    def in_round_one
      unless @game.current_round == 1
        flash[:error] = "This action can only be performed in round 1"
        redirect_to root_path
      end
    end
    
    def in_round_two
      unless @game.current_round == 2
        flash[:error] = "This action can only be performed in round 2"
        redirect_to root_path
      end
    end

    def not_in_round_one
      if @game.current_round == 1
        flash[:error] = "This action cannot be performed on round 1"
        redirect_to root_path
      end
    end
    
end
