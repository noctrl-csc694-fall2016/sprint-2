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
    
      # Search donor on ID Only (IE: 1)
      if (((d.id.to_s).include? searchTerm) && (!resultsFound))
        resultsFound = true
      end
      
      # Search donor on "DON"ID Only (IE: DON1)
      if ((("don" + d.id.to_s).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search donor on First Name (IE: John)
      if (((d.first_name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search donor on Last Name (IE: Smith)
      if (((d.last_name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search donor on Full Name (IE: John Smith)
      if (((d.first_name.downcase + " " + d.last_name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search donor on City (IE: Plainfield)
      if (((d.city.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search donor on State (IE: IL or Illinois)
      if (((d.state.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search donor on Zip (IE: 60544)
      if (((d.zip.to_s).include? searchTerm) && (!resultsFound))
        resultsFound = true
      end
      
      # Search donor on E-Mail (IE: JohnSmith@gmail.com)
      if (((d.email.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Update array if we match
      if resultsFound == true
        # Primary Array
        searchResults = Array.new(4)
        
        # Populate Array
        searchResults[0] = "Donor"
        searchResults[1] = "DON" + d.id.to_s
        searchResults[2] = "Name: " + d.first_name + " " + d.last_name + "\n\n" + "E-Mail: " + d.email
        searchResults[3] = "/donors/" + d.id.to_s + "/edit"
        
        # Pass Into Result
        @fullResultSet << searchResults
      end
    end
    
    # Search Activities
    activities = Activity.all
    
    # Loop on the activities
    activities.each do |a|
      # Assume no match on each loop
      resultsFound = false
       
      # Search activitivy on ID Only (IE: 1)
      if (((a.id.to_s).include? searchTerm) && (!resultsFound))
        resultsFound = true
      end
      
      # Search activity on "ACT"ID Only (IE: ACT1)
      if ((("act" + a.id.to_s).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search activity on title (IE: "Turkey")
      if (((a.name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
        
      # Search activity on desc. (IE: "Bowling")
      if (((a.description.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search activity type (IE: Mailer)
      if (((a.activity_type.to_s.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Update array if we match
      if resultsFound == true
        # Primary Array
        searchResults = Array.new(4)
        
        # Populate Array
        searchResults[0] = "Activity"
        searchResults[1] = "ACT" + a.id.to_s
        searchResults[2] = "Name: " + a.name + "\n\n" + "Description: " + a.description
        searchResults[3] = "/activities/" + a.id.to_s + "/edit"
        
        # Pass Into Result
        @fullResultSet << searchResults
      end
    end
    
    # Search Gifts
    gifts = Gift.all
    
     # Loop on the gifts
    gifts.each do |g|
      # Assume no match on each loop
      resultsFound = false
      
      # Search gift on ID Only (IE: 1)
      if (((g.id.to_s).include? searchTerm) && (!resultsFound))
        resultsFound = true
      end
      
      # Search activity on "GFT"ID Only (IE: ACT1)
      if ((("gft" + g.id.to_s).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Check Donation First Name (IE: Brian)
      if (((Donor.find(g.donor).first_name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Check Donation Last Name (IE: Brian Brown)
      if (((Donor.find(g.donor).last_name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Check Donation Full Name (IE: Brian Brown)
      giftFullName = (Donor.find(g.donor).first_name.downcase) + " " + (Donor.find(g.donor).last_name.downcase)
      if ((giftFullName.include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Check Donation Activity (IE: Some Event)
      if (((Activity.find(g.activity).name.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Search Gift Type (IE: Cash)
      if (((g.gift_type.to_s.downcase).include? searchTerm.downcase) && (!resultsFound))
        resultsFound = true
      end
      
      # Update array if we match
      if resultsFound == true
        # Primary Array
        searchResults = Array.new(4)
        
        # Populate Array
        searchResults[0] = "Gift"
        searchResults[1] = "GFT" + g.id.to_s
        searchResults[2] = "Donor: " + Donor.find(g.donor).first_name.to_s + " " + Donor.find(g.donor).last_name.to_s + "\n\n" + "Activity: " + (Activity.find(g.activity).name)
        searchResults[3] = "/gifts/" + g.id.to_s + "/edit"
        
        # Pass Into Result
        @fullResultSet << searchResults
      end
    end
  end
  
  private
    #define surf parameters accepted and required
    def hypersurf_params
      params.required(:term)
    end

end
