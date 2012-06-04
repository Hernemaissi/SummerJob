class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  protected
    
    def teacher_user
      redirect_to(root_path) unless  signed_in? && current_user.isTeacher?
    end
    
    def signed_in_user
      store_location
      redirect_to signin_path, notice: "Please sign in." unless signed_in?
    end
    
    def company_owner
      @company = Company.find(params[:id])
      if !signed_in? || !current_user.group || !current_user.group.company || !(current_user.group.company.id == @company.id)
        unless signed_in? && current_user.isTeacher?
          redirect_to(root_path)
        end
      end
    end
    
end
