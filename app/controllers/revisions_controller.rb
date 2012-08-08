class RevisionsController < ApplicationController

  def show
    @revision = Revision.find(params[:id])
  end
end
