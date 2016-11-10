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
  
  def activities
    @activity_search_results = Activity.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
  end
  
  def all
    # Get Search Var
    searchTerm = params[:term].downcase
    # Prime a return
    @fullResultSet = Array.new
    
    # Search The Donors
    donors = Donor.all
    donors.each do |d|
      # Assume no match on each loop
      resultsFound = false 
    
      if (((d.first_name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      if (((d.last_name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      if (((d.address.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      if (((d.city.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      if (((d.state.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      if (((d.zip.to_s).include? searchTerm) && (!resultsFound))
        resultsFound = true
      end
      
      if (((d.email.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      if resultsFound == true
        # Primary Array
        searchResults = Array.new(4)
        
        # Populate Array
        searchResults[0] = "Donor"
        searchResults[1] = "DON" + d.id.to_s
        searchResults[2] = d.first_name + " " + d.last_name
        searchResults[3] = d.id
        
        # Pass Into Result
        @fullResultSet << searchResults
      end
    end
    
    # Surf All Gifts
    
    # Surf All Activities
  end
  
  private
    #define surf parameters accepted and required
    def hypersurf_params
      params.required(:term)
    end

end
