  #----------------------------------#
  # HyperSurf Controller
  # original written by: Jason K, Oct 17 2016
  # major contributions by:
  #
  #----------------------------------#

class HyperSurfController < ApplicationController
  def donors
    @donor_search_results = Donor.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
  end
  
  def all
    @all_search_results = Donor.search(params[:term]).paginate(:per_page => 5, :page => params[:page])
  end
  
  private
    #define surf parameters accepted and required
    def hypersurf_params
      params.required(:term)
    end

end
