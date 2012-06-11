class CompaniesController < ApplicationController
  before_filter :teacher_user,     only: [:new, :index]
  before_filter :company_owner,   only: [:mail]
  
  def new
    @company = Company.new
    groups = Group.all
    @free_groups = Group.free(groups)
  end

  def create
    @group = Group.find_by_id(params[:group][:id])
    if !@group
      flash.now[:error] = "Please specify a owner"
      @company = Company.new(params[:company])
      groups = Group.all
      @free_groups = Group.free(groups)
      render 'new'
    else
      @company = @group.create_company(params[:company])
      @company.name = "Group #{@group.id}'s company"
      if @company.save
        flash[:success] = "Created a new company"
        redirect_to companies_path
      else
        groups = Group.all
        @free_groups = Group.free(groups)
        render 'new'
      end
    end
  end

  def show
    @company = Company.find(params[:id])
    if !@company.initialised?
      if signed_in? && current_user.isOwner?(@company) && !current_user.isTeacher?
        flash[:notice] = "Please fill some basic information about your company"
        redirect_to init_path(:id => @company.id)
      else
        if signed_in? && current_user.isTeacher?
          redirect_to need_path(@company.id)
        else
          flash[:error] = "Company has not been founded yet"
          redirect_to root_path
        end
      end
    end
  end

  def index
    @companies = Company.all
  end
  
  def update
    @company = Company.find(params[:id])
    @company.update_attributes(params[:company])
    if @company.save && update_stats(@company)
      flash[:success] = "Successfully updated company information"
      @company.initialised = true
      @company.save(valitedate: false)
      redirect_to @company
    else
      render 'init'
    end
  end
  
  def init
    @company = Company.find(params[:id])
    @stat_hash = stat_hash(1)
    if  @company.initialised?
      flash[:error] = "This company has already been founded"
      redirect_to @company
    end
  end
  
  def get_stats
    @stat_hash = stat_hash(Integer(params[:size]))
    respond_to do |format| 
      format.js
    end
  end
  
  def mail
    @company = Company.find(params[:id])
  end
end
