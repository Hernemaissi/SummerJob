class QualityvaluesController < ApplicationController

  def show
    @qualityvalue = Qualityvalue.find(params[:id])

    respond_to do |format|
      format.js
    end

  end
end
