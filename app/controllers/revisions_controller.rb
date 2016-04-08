=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

class RevisionsController < ApplicationController
  before_filter :plan_is_public?, only: [:show]
  before_filter :teacher_user, only: [:update]

  def show
    @revision = Revision.find(params[:id])
    @revision.update_attribute(:read, true) if signed_in? && !current_user.teacher && current_user.isOwner?(@revision.company)
  end

  def update
    @revision = Revision.find(params[:id])
    @revision.update_attributes(params[:revision])
    if @revision.save
      flash[:success] = "Revision graded succesfully"
      @revision.company.bonus_capital_from_business_plan(@revision.grade) unless @revision.company.business_plan.grade
      @revision.company.business_plan.update_attribute(:grade, @revision.grade)
      redirect_to @revision
    else
      flash[:error] = "Grading failed, please try again"
      redirect_to @revision
    end
  end

  def print
    @revisions = []
    Company.all.each do |c|
      @revisions << c.revisions.last unless c.revisions.empty?
    end
    render :layout => false
  end

  private

  def plan_is_public?
    @revision = Revision.find(params[:id])
    unless (signed_in? && current_user.isOwner?(@revision.company)) || @revision.company.business_plan.public?
      flash[:error] = "This company has not set their plan as public"
      redirect_to @revision.company
    end
  end
end
