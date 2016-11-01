  #----------------------------------#
  # HyperSurf Controller
  # original written by: Jason K, Oct 17 2016
  # major contributions by:
  #
  #----------------------------------#

class HyperSurfController < ApplicationController
  def Donors
    render 'donors'
  end
  
  def All
    @hypersurf = HyperSurf.new(hypersurf_params)
    if params[:term].blank?
      flash[:error] = "Search query is empty."
    elsif params[:term].length > 3
      flash[:error] = "Search query must be at least 3 characters long."
    else
      render 'all'
    end 
  end
  
  private
    #define surf parameters accepted and required
    def hypersurf_params
      params.required(:term)
    end

end
