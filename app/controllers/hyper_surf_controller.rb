  #----------------------------------#
  # HyperSurf Controller
  # original written by: Jason K, Oct 17 2016
  # major contributions by:
  #
  #----------------------------------#

class HyperSurfController < ApplicationController
  #----------------------------------#
  # HyperSurf.All Method
  # Queries each model within the application
  # and bulds an array where specific fields 
  # contain values that are located within the query
  # The method then returns an array to be displayed
  #----------------------------------#
  #users must be logged into access any of this controller's methods/views
  before_action :logged_in
  
  def all
    # Get Search Var
    searchTerm = params[:term].downcase
    # Prime a return
    @fullResultSet = Array.new
    
    #----------------------------------#
    # Search The Donors
    #----------------------------------#
    donors = Donor.all.sort { |a,b| a.full_name_id <=> b.full_name_id }
    donors.each do |d|
      # Assume no match on each loop
      resultsFound = false 
    
      # Search donor on ID Only (IE: 1)
      if ((!resultsFound) && ((d.id.to_s).include? searchTerm))
        resultsFound = true
      end
      
      # Search donor on "DON"ID Only (IE: DON1)
      if ((!resultsFound) && (("don" + d.id.to_s).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search donor on First Name (IE: John)
      if ((!resultsFound) && ((d.first_name.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search donor on Last Name (IE: Smith)
      if ((!resultsFound) && ((d.last_name.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search donor on Full Name (IE: John Smith)
      if ((!resultsFound) && ((d.first_name.downcase + " " + d.last_name.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search donor on City (IE: Plainfield)
      if ((!resultsFound) && ((d.city.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search donor on State (IE: IL or Illinois)
      if ((!resultsFound) && ((d.state.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search donor on Zip (IE: 60544)
      if ((!resultsFound) && ((d.zip.to_s).include? searchTerm))
        resultsFound = true
      end
      
      # Search donor on E-Mail (IE: JohnSmith@gmail.com)
      if ((!resultsFound) && ((d.email.downcase).include? searchTerm.downcase))
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
    
    #----------------------------------#
    # Search Activities
    #----------------------------------#
    activities = Activity.all.sort { |a,b| a.start_date <=> b.start_date }
    
    # Loop on the activities
    activities.each do |a|
      # Assume no match on each loop
      resultsFound = false
       
      # Search activitivy on ID Only (IE: 1)
      if ((!resultsFound) && ((a.id.to_s).include? searchTerm))
        resultsFound = true
      end
      
      # Search activity on "ACT"ID Only (IE: ACT1)
      if ((!resultsFound) && (("act" + a.id.to_s).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search activity on title (IE: "Turkey")
      if ((!resultsFound) && ((a.name.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
        
      # Search activity on desc. (IE: "Bowling")
      if ((!resultsFound) && ((a.description.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search activity type (IE: Mailer)
      if ((!resultsFound) && ((a.activity_type.to_s.downcase).include? searchTerm.downcase))
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
    
    #----------------------------------#
    # Search Gifts
    #----------------------------------#
    gifts = Gift.all.sort { |a,b| a.donation_date <=> b.donation_date }
    
     # Loop on the gifts
    gifts.each do |g|
      # Assume no match on each loop
      resultsFound = false
      
      # Search gift on ID Only (IE: 1)
      if ((!resultsFound) && ((g.id.to_s).include? searchTerm))
        resultsFound = true
      end
      
      # Search activity on "GFT"ID Only (IE: ACT1)
      if ((!resultsFound) && (("gft" + g.id.to_s).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Check Donation First Name (IE: Brian)
      if ((!resultsFound) && ((Donor.find_by(id: g.donor).first_name.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Check Donation Last Name (IE: Brian Brown)
      if ((!resultsFound) && ((Donor.find_by(id: g.donor).last_name.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Check Donation Full Name (IE: Brian Brown)
      giftFullName = (Donor.find_by(id: g.donor).first_name.downcase) + " " + (Donor.find_by(id: g.donor).last_name.downcase)
      if ((!resultsFound) && (giftFullName.include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Check Donation Activity (IE: Some Event)
      if ((!resultsFound) && ((Activity.find_by(id: g.activity).name.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Search Gift Type (IE: Cash)
      if ((!resultsFound) && ((g.gift_type.to_s.downcase).include? searchTerm.downcase))
        resultsFound = true
      end
      
      # Update array if we match
      if resultsFound == true
        # Primary Array
        searchResults = Array.new(4)
        
        # Populate Array
        searchResults[0] = "Gift"
        searchResults[1] = "GFT" + g.id.to_s
        searchResults[2] = "Donor: " + Donor.find_by(id: g.donor).first_name.to_s + " " + Donor.find_by(id: g.donor).last_name.to_s + "\n\n" + "Activity: " + (Activity.find_by(id: g.activity).name)
        searchResults[3] = "/gifts/" + g.id.to_s + "/edit"
        
        # Pass Into Result
        @fullResultSet << searchResults
      end
    end
    
    #----------------------------------#
    # Misc Checks For About Page
    #----------------------------------#
    if (searchTerm.downcase == "about") || (searchTerm.downcase == "developers") || (searchTerm.downcase == "more information") || (searchTerm.downcase == "the scoop")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "About Page: Learn about Gift Garden and those who made an impact on this project.  Click within this row to go to the About Page."
      searchResults[3] = "/about"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
    # Misc Checks For Help Page
    if (searchTerm.downcase == "help") || (searchTerm.downcase == "help me") || (searchTerm.downcase == "lost") || (searchTerm.downcase == "what the heck")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "Help Page: Find help articles and contact information for assistance in regards to your travels on Gift Garden.  Click within this row to go to the Help Page."
      searchResults[3] = "/help"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
    # Misc Checks For Reports
    if (searchTerm.downcase == "reports") || (searchTerm.downcase == "exotic reports") || (searchTerm.downcase == "basic reports") || (searchTerm.downcase == "data dump") || (searchTerm.downcase == "pour some data on me")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "Reports Page: Generate reports quickly and easily.  Click within this row to go to the Reports Page."
      searchResults[3] = "/reports"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
     # Misc Checks For Import Export
    if (searchTerm.downcase == "import") || (searchTerm.downcase == "export") || (searchTerm.downcase == "csv") || (searchTerm.downcase == "excel") || (searchTerm.downcase == "the weight") || (searchTerm.downcase == "mailchip") || (searchTerm.downcase == "constant contact") || (searchTerm.downcase == "data load") || (searchTerm.downcase == "backup")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "Import/Export Page: Import data into the system and export out to key third-parties.  Click within this row to go to the Import/Export Page."
      searchResults[3] = "/import-export"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
    # Misc Checks For Activities
    if (searchTerm.downcase == "activities") || (searchTerm.downcase == "activity") || (searchTerm.downcase == "create activity") || (searchTerm.downcase == "update activity") || (searchTerm.downcase == "delete activity")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "Surf Activities: Manage Activities within Donna Donner.  Click within this row to go to the Surf Activities Page."
      searchResults[3] = "/activities?utf8=✓&timeframe=All&topn=All&sortby=&commit=GO"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
    # Misc Checks For Donors
    if (searchTerm.downcase == "donors") || (searchTerm.downcase == "donor") || (searchTerm.downcase == "create donors") || (searchTerm.downcase == "update donors") || (searchTerm.downcase == "delete donors")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "Surf Donors: Manage Donors within Donna Donner.  Click within this row to go to the Surf Donors Page."
      searchResults[3] = "/donors?utf8=✓&timeframe=All&topn=All&sortby=&commit=GO"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
    # Misc Checks For Gifts
    if (searchTerm.downcase == "gifts") || (searchTerm.downcase == "gift") || (searchTerm.downcase == "create gifts") || (searchTerm.downcase == "update gifts") || (searchTerm.downcase == "delete gifts")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "Surf Gifts: Manage Gifts within Donna Donner.  Click within this row to go to the Surf Gifts Page."
      searchResults[3] = "/gifts?utf8=✓&activity_id=&donor_id=&timeframe=&topn=&sortby=&commit=GO"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
    # Misc Checks For Home
    if (searchTerm.downcase == "home") || (searchTerm.downcase == "home page") || (searchTerm.downcase == "the beginning")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "Please click within this row to go to the Home Page"
      searchResults[3] = "/home"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
    # Misc Checks For Users
    if (searchTerm.downcase == "team") || (searchTerm.downcase == "jason k") || (searchTerm.downcase == "andy w") || (searchTerm.downcase == "wei h") || (searchTerm.downcase == "pat m") || (searchTerm.downcase == "professor bill")  || (searchTerm.downcase == "mike d")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "The Development Team: Meet the team that build the very application that you are using today.  Please click within this row to view the entire development team."
      searchResults[3] = "/home"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
    # Easter Eggs
    if (searchTerm.downcase == "uuddlrlrbass") || (searchTerm.downcase == "Konami Code") || (searchTerm.downcase == "Infinite Lives")
      # Primary Array
      searchResults = Array.new(4)
      # Populate Array
      searchResults[0] = "Content"
      searchResults[1] = "-"
      searchResults[2] = "Do you like hunting for Easter Eggs?"
      searchResults[3] = "/home"
      
      # Pass Into Result
      @fullResultSet << searchResults
    end
    
  end
  
  private
    #define surf parameters accepted and required
    def hypersurf_params
      params.required(:term)
    end

end
