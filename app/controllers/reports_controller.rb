class ReportsController < ApplicationController
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  #Setup Activities Report View
  #renders the basic activities report view
  def activities_setup
    @activities = Activity.all
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  
  #Basic Activities Report
  #This creates the content that is sent to the basic activities report.
  #It iterates per activity, filtering based on the form parameters passed in.
  def activities_report
    respond_to do |format|
      format.html
        @activities = Activity.all
        @reportActivitiesArray = []
        # filter out activities based on the parameters put in the form
        @timeframe = params[:timeframe]
        @sortby = params[:sortby]
        @progressFilter = false
        @user = current_user
        
        #apply timeframe filter
        @activities.each do |activity|
          case @timeframe
          when 'All'
            @reportActivitiesArray.push(activity)
          when 'This Year'
            if is_current_year(activity['end_date'].to_datetime)
              @reportActivitiesArray.push(activity)
            end
          when 'This Quarter'
            if ((is_current_quarter(activity['end_date'].to_datetime)) && 
              (is_current_year(activity['end_date'].to_datetime)))
              @reportActivitiesArray.push(activity)
            end
          when 'This Month'
            if ((is_current_month(activity['end_date'].to_datetime)) && 
              (is_current_year(activity['end_date'].to_datetime)))
              @reportActivitiesArray.push(activity)
            end
          when 'Last Year'
            if is_last_year(activity['end_date'].to_datetime)
              @reportActivitiesArray.push(activity)
            end
          when 'Last Quarter'
            if is_last_quarter(activity['end_date'].to_datetime)
              @reportActivitiesArray.push(activity)
            end
          when 'Last Month'      
            if is_last_month(activity['end_date'].to_datetime)
              @reportActivitiesArray.push(activity)
            end
          when 'Past 2 Years'
            if ((is_last_year(activity['end_date'].to_datetime)) or
              (is_current_year(activity['end_date'].to_datetime)))
              @reportActivitiesArray.push(activity)
            end
          when 'Past 5 Years'
            if is_past_5_years(activity['end_date'].to_datetime)
              @reportActivitiesArray.push(activity)
            end
          when 'Past 2 Quarters'
            if (
                ((is_current_quarter(activity['end_date'])) and 
                (is_current_year(activity['end_date']))) or
                (is_last_quarter(activity['end_date']))
              )
              @reportActivitiesArray.push(activity)
            end
          when 'Past 3 Months'
            if (is_past_3_months(activity['end_date'].to_datetime))
              @reportActivitiesArray.push(activity)
            end
          when 'Past 6 Months'
            if (is_past_6_months(activity['end_date'].to_datetime))
              @reportActivitiesArray.push(activity)
            end
          end
          
        end
        
        #apply sortby filter
        case @sortby
          when 'Name'
            @reportActivitiesArray.sort! { |a,b| a.name.downcase <=> b.name.downcase }
          when 'Start Date'
            @reportActivitiesArray.sort! { |b,a| a.start_date <=> b.start_date }
          when 'End Date'
            @reportActivitiesArray.sort! { |b,a| a.end_date <=> b.end_date }
          when 'Goal'
            @reportActivitiesArray.sort! { |b,a| a.goal <=> b.goal }
          when 'Progress'
            @progressFilter = true #this filter is done separately during report generation
            
            @reportActivitiesArray.each do |act|
              #calculate associated gifts total
              begin
                gifts = Gift.find([act.id])
              rescue ActiveRecord::RecordNotFound
                gifts = nil #if no matches found
              end
              giftTotal = 0;
              if gifts.nil? || gifts == 0
                giftTotal = 0
              else
                giftTotal = giftTotal.to_i
                gifts.each do |gift|
                  giftTotal += gift.amount.to_i
                end
              end
              
              #calculate progress % to goal
              if ((giftTotal == 0) or (act.goal == 0))#handles General activity
                progressPercentage = 0
              else
                progressTotal = act.goal.to_i
                progressAmount = giftTotal.to_i
                progressFloat = (progressAmount.to_f) / (progressTotal.to_f) * 100
                progressPercentage = progressFloat.round#.to_s + '%'
              end
              
              #put result in notes field temporarily  
              if progressPercentage === 0 && giftTotal > 0
                act.notes = "0"
              elsif progressPercentage === 0 #giftTotal is <= 0
                act.notes = "-1"
              else
                act.notes = progressPercentage.to_s
              end
            end
            #now sort
            @reportActivitiesArray.sort! { |b,a| a.notes.to_i <=> b.notes.to_i }
            #now convert percent complete back to more readable form for reports
            @reportActivitiesArray.each do |a|
              if a.notes === 0
                a.notes = "0%"
              elsif a.notes.to_i === -1
                a.notes = ""
              else
                a.notes = a.notes.to_s + "%"
              end
            end
        end

        #generate the pdf file for the report
        pdf = ActivityPdf.new(@reportActivitiesArray, @timeframe, @sortby, @progressFilter, @user)
        send_data pdf.render, :filename => 'Activities Report' + " " + Time.now.to_date.to_s + '.pdf', 
        :type => 'application/pdf', :disposition => 'attachment'
        flash[:success] = "Activity report generated."
    end
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  #Setup Donors Report View
  #renders the basic donors report view
  def donors_setup
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  #Basic Donors Report
  #this creates the content that is sent to the basic donors report.
  #It iterates per donor, filtering based on the form parameters passed in.
  def donors_report
    respond_to do |format|
      format.html
      @donors = Donor.all
      @gifts = Gift.all
      @reportDonorsArray = []
      @donorGiftsTotal = 0
      #parameters from the form view
      @timeframe = params[:times]
      @sortby = params[:sorts]
      @topn = params[:topn]
      @fullcontact = params[:landscape]
      @user = current_user
      
      @donors.each do |donor|
        
        #first grab all gifts from the chosen donor
        currentDonor = donor
        @donorGiftsArray = [] #donor's gifts go in here
        @giftsWithinTimeArray = [] #gifts that apply to timeframe filter go here
        
        @gifts.each do |gift|
          donorID = gift['donor_id']
          if donorID.to_s.eql? currentDonor['id'].to_s
            @donorGiftsArray.push(gift)
          end #end if
        end #end gifts loop
        #donor['address2'] = @donorGiftsArray.length #for testing - remove later
        
        if @donorGiftsArray.length > 0 
          addDonor = false  #flag for adding donor to report
          
          #apply timeframe filter
          case @timeframe
          when 'All'
            #should this include donors with NO gifts? currently it doesn't
            #all option adds both ALL of this donor's gifts and their gift total
            addDonor = true
            add_donor_and_gifts_if_applicable(addDonor, donor, @donorGiftsArray)
          when 'This Year'
            @donorGiftsArray.each do |gift|
              if is_current_year(gift['donation_date'].to_datetime)
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'This Quarter'
            @donorGiftsArray.each do |gift|
              if ((is_current_quarter(gift['donation_date'].to_datetime)) && 
              (is_current_year(gift['donation_date'].to_datetime)))
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'This Month'
            @donorGiftsArray.each do |gift|
              if ((is_current_month(gift['donation_date'].to_datetime)) && 
              (is_current_year(gift['donation_date'].to_datetime)))
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'Last Year'
            @donorGiftsArray.each do |gift|
              if is_last_year(gift['donation_date'].to_datetime)
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'Last Quarter'
            @donorGiftsArray.each do |gift|
              if is_last_quarter(gift['donation_date'].to_datetime)
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'Last Month'      
            @donorGiftsArray.each do |gift|
              if is_last_month(gift['donation_date'].to_datetime)
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'Past 2 Years'
            @donorGiftsArray.each do |gift|
              if ((is_last_year(gift['donation_date'].to_datetime)) or
              (is_current_year(gift['donation_date'].to_datetime)))
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'Past 5 Years'
            @donorGiftsArray.each do |gift|
              if is_past_5_years(gift['donation_date'].to_datetime)
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'Past 2 Quarters'
            @donorGiftsArray.each do |gift|
              if (
                ((is_current_quarter(gift['donation_date'])) and 
                (is_current_year(gift['donation_date']))) or
                (is_last_quarter(gift['donation_date']))
              )
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'Past 3 Months'
            @donorGiftsArray.each do |gift|
              if (is_past_3_months(gift['donation_date'].to_datetime))
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          when 'Past 6 Months'
            @donorGiftsArray.each do |gift|
              if (is_past_6_months(gift['donation_date'].to_datetime))
                addDonor = true
                @giftsWithinTimeArray.push(gift)
              end
            end
            add_donor_and_gifts_if_applicable(addDonor, donor, @giftsWithinTimeArray)
          end #end switch for timeframe
        else
          #apply timeframe filter
          case @timeframe
          when 'All'
            #donors with no gifts are still added in this filter
            add_donor_with_no_gifts(donor)
          end
        end #end donorGiftsArray length check
      end #end donors loop
        
      #apply sortby filter
      case @sortby
        when 'Last Name'
          @reportDonorsArray.sort! { |a,b| a.last_name.downcase <=> b.last_name.downcase }
        when 'First Name'
          @reportDonorsArray.sort! { |a,b| a.first_name.downcase <=> b.first_name.downcase }
        when 'Email'
          @reportDonorsArray.sort! { |a,b| a.email <=> b.email }
        when 'State'
          @reportDonorsArray.sort! { |a,b| a.state <=> b.state }
        when 'Date of Last Gift'
          #title field of donor is used to store last gift date. sort these
          @reportDonorsArray.sort! { |b,a| a.title <=> b.title }
        when 'Gift Total'
          #nickname field of donor is used to store last gift date. sort these
          @reportDonorsArray.sort! { |b,a| a.nickname.to_i <=> b.nickname.to_i }
      end
      
      #apply topn filter
      case @topn
      when 'all'
      when '10'
        @reportDonorsArray = @reportDonorsArray.first(10)
      when '20'
        @reportDonorsArray = @reportDonorsArray.first(20)
      when '50'
        @reportDonorsArray = @reportDonorsArray.first(50)
      when '100'
        @reportDonorsArray = @reportDonorsArray.first(100)
      end
      
      #generate the pdf file for the report
      #landscape donors report will be the full contact report
      if @fullcontact
        pdf = ContactPdf.new(@reportDonorsArray, @timeframe, @sortby, @topn, @user)
        send_data pdf.render, :filename => 'Donors Full Contact Report' + " "  + 
        Time.now.to_date.to_s + '.pdf', 
        :type => 'application/pdf', :disposition => 'attachment'
      else
        #portrait donors report will be the normal basic donors report
        pdf = DonorPdf.new(@reportDonorsArray, @timeframe, @sortby, @topn, 
        @donorGiftsTotal, @user)
        send_data pdf.render, :filename => 'Donors Report' + " "  + 
        Time.now.to_date.to_s + '.pdf', 
        :type => 'application/pdf', :disposition => 'attachment'
      end
    end
  end
  
  #determines if a donor should be added to the basic donors report, 
  #depending on whether or not their gifts apply to that report's parameters.
  def add_donor_and_gifts_if_applicable(isOK, donor, giftsArray)
    if isOK #add donor if one of the gifts was within the timeframe
      #determine the latest gift date and add that to the report
      lastGiftDate = '1900-01-01'.to_date
      giftsTotalAmount = 0
      giftsArray.each do |gift|
        if gift['donation_date'] > lastGiftDate
          lastGiftDate = gift['donation_date']
        end
        giftsTotalAmount = giftsTotalAmount + gift['amount']
      end
      #add the last gift date using title field of donor
      donor['title'] = lastGiftDate.to_s
      #add the total gifts amount using nickname field of donor
      donor['nickname'] = giftsTotalAmount.to_i.to_s
      @donorGiftsTotal = @donorGiftsTotal + giftsTotalAmount.to_i
      @reportDonorsArray.push(donor)
    end
  end
  
  #adds a no-gift donor to the basic donors report
  #the title and nickname fields are blank because they are used to hold gift 
  #information in the report normally
  def add_donor_with_no_gifts(donor)
    donor['title'] = ''
    donor['nickname'] = ''
    @reportDonorsArray.push(donor)
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  
  #Setup Gifts Report View
  #renders the basic gifts report view
  def gifts_setup
    @activities = Activity.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
    #@activities = Activity.all
    #@activities = Activity.all.sortby(:name)
    #@activities = Activity.all.map { |activity| [ activity.name, activity.id ] }
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  
  #Basic Gifts Report
  #this creates the content that is sent to the basic gifts report.
  #It iterates per gift, filtering based on the form parameters passed in.
  def gifts_report
    respond_to do |format|
      format.html
        @gifts = Gift.all
        #@founders.map{|founder| [founder.founder_name, founder.id]}.sort{|a,b| a.founder_name.downcase <=> b.founder_name.downcase
        #@activities = Activity.all.map { |activity| [ activity.name, activity.id ] }.sort{|a,b| a.name.downcase <=> b.name.downcase }
        @activities = Activity.all
        @reportGiftsArray = []  
        @activityGiftsArray = []
        @activity = params[:activity]
        @topn = params[:topn]
        @timeframe = params[:times]
        @sortby = params[:sorts]
        @fullcontact = params[:landscape]
        @user = current_user
        
        #first grab all gifts from the chosen activity
        activity = Activity.find(@activity)
        @gifts.each do |gift|
          actID = gift['activity_id']
          if actID.to_s.eql? activity['id'].to_s
            @activityGiftsArray.push(gift)
          end
        end
        
        #apply timeframe filter
        @activityGiftsArray.each do |gift|
          case @timeframe
          when 'All'
            @reportGiftsArray.push(gift)
          when 'This Year'
            if is_current_year(gift['donation_date'])
              @reportGiftsArray.push(gift)  
            end
          when 'This Quarter'
            if ((is_current_quarter(gift['donation_date'].to_datetime)) && 
              (is_current_year(gift['donation_date'].to_datetime)))
              @reportGiftsArray.push(gift)  
            end
          when 'This Month'
            if ((is_current_month(gift['donation_date'].to_datetime)) && 
              (is_current_year(gift['donation_date'].to_datetime)))
              @reportGiftsArray.push(gift)  
            end
          when 'Last Year'
            if is_last_year(gift['donation_date'].to_datetime)
              @reportGiftsArray.push(gift)
            end
          when 'Last Quarter'
            if is_last_quarter(gift['donation_date'].to_datetime)
              @reportGiftsArray.push(gift)
            end
          when 'Last Month'      
            if is_last_month(gift['donation_date'].to_datetime)
              @reportGiftsArray.push(gift)
            end
          when 'Past 2 Years'
            if ((is_last_year(gift['donation_date'].to_datetime)) or
              (is_current_year(gift['donation_date'].to_datetime)))
              @reportGiftsArray.push(gift)
            end
          when 'Past 5 Years'
            if is_past_5_years(gift['donation_date'].to_datetime)
              @reportGiftsArray.push(gift)
            end
          when 'Past 2 Quarters'
            if (
                ((is_current_quarter(gift['donation_date'])) and 
                (is_current_year(gift['donation_date']))) or
                (is_last_quarter(gift['donation_date']))
              )
              @reportGiftsArray.push(gift)
            end
          when 'Past 3 Months'
            if (is_past_3_months(gift['donation_date'].to_datetime))
              @reportGiftsArray.push(gift)
            end
          when 'Past 6 Months'
            if (is_past_6_months(gift['donation_date'].to_datetime))
              @reportGiftsArray.push(gift)
            end
          end
        end
        
        #apply sort filter
        case @sortby
          when 'Gift ID'
            @reportGiftsArray.sort! { |b,a| a.id <=> b.id }
          when 'Amount'
            @reportGiftsArray.sort! { |b,a| a.amount.to_i <=> b.amount.to_i }
          when 'Gift Date'
            @reportGiftsArray.sort! { |b,a| a.donation_date <=> b.donation_date }
          when 'Gift Type'
            @reportGiftsArray.sort! { |a,b| a.gift_type <=> b.gift_type }
          when 'Donor Name'
            @reportGiftsArray.each do |g|
              donorName = ''
              donor = Donor.find([g.donor_id])
              donor.each do |d|
                donorName = d.last_name + ", " + d.first_name
              end
              g.solicited_by = donorName
            end
            @reportGiftsArray.sort! { |a,b| a.solicited_by <=> b.solicited_by }
        end
        
        #apply topn filter
        case @topn
        when 'all'
        when '10'
          @reportGiftsArray = @reportGiftsArray.first(10)
        when '20'
          @reportGiftsArray = @reportGiftsArray.first(20)
        when '50'
          @reportGiftsArray = @reportGiftsArray.first(50)
        when '100'
          @reportGiftsArray = @reportGiftsArray.first(100)
        end
        
        #generate pdf file
        #landscape gifts report will be the full contact report
        if @fullcontact
          pdf = GiftContactPdf.new(@reportGiftsArray, @timeframe, @sortby, @topn, @user)
          send_data pdf.render, :filename => 'Gifts Full Contact Report' + " "  + 
          Time.now.to_date.to_s + '.pdf', 
          :type => 'application/pdf', :disposition => 'attachment'
        else
          pdf = GiftPdf.new(@reportGiftsArray, @timeframe, @sortby, @topn, @user)
          send_data pdf.render, :filename => 'Gifts Report' + " "  + 
          Time.now.to_date.to_s + '.pdf', 
          :type => 'application/pdf', :disposition => 'attachment'
        end
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  #Trash Report 
  #this creates the content that is sent to the trash report.
  def trash_report
    respond_to do |format|
      format.html
      @trash = Trash.all
      @user = current_user
      
      #generate pdf file
      pdf = TrashPdf.new(@trash, @user)
      send_data pdf.render, :filename => 'trashReport-' + Time.now.to_date.to_s + '.pdf', :type => 'application/pdf', :disposition => 'attachment'
    end
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  #SetupOne Donor Report View
  #renders the basic activities report view
  def one_donor_setup
    @donors = Donor.all.sort { |a,b| a.full_name_id <=> b.full_name_id }
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # One Donor Report
  # Per a given selected donor, return a report of contact information and all gifts
  def one_donor_report
    respond_to do |format|
      format.html
      
      # Grab and store donor data
      donor_profile = Donor.find(params[:donor])
      
      # Requestor Data
      requestorData = current_user.username
      
      # Store our donor profile
      donorData = Array.new(9)
      donorData[0] = "DON" + donor_profile.id.to_s
      donorData[1] = donor_profile.first_name
      donorData[2] = donor_profile.last_name
      donorData[3] = donor_profile.address
      donorData[4] = donor_profile.address2
      donorData[5] = donor_profile.city 
      donorData[6] = donor_profile.state
      donorData[7] = donor_profile.zip.to_s
      donorData[8] = donor_profile.phone
      donorData[9] = donor_profile.email
      
      # Get gifts
      selectedGiftsArray = Array.new
      
      selectedGifts = Gift.order(donation_date: :desc).where(:donor_id => params[:donor])
      selectedGiftsCount = selectedGifts.count.to_s
      selectedGiftsSum = selectedGifts.sum(:amount).to_s
      #first grab all gifts from the chosen activity
      selectedGifts.each do |gift|
        selectedGiftsArray.push(gift)
      end
      
      selectedGiftsArray.sort! { |a,b| a.donation_date <=> b.donation_date }
      
      #generate pdf file
      pdf = OneDonorPdf.new(requestorData, donorData, selectedGiftsArray, selectedGiftsCount, selectedGiftsSum)
      send_data pdf.render, :filename => 'One Donor Report - ' + donor_profile.full_name + '-' + Time.now.to_date.to_s + '.pdf', :type => 'application/pdf', :disposition => 'attachment'
    end 
  end
    
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # LUBUNT (Last year but unfortunately not this) Report
  # Find all donors that donated last year (or previous years), but have not yet donated this year
    def lybunt_report
      respond_to do |format|
        format.html
        @donors = Donor.all
        @reportDonorsArray = []
        #parameters from the form view
        @timeframe = params[:times]
        @sortby = params[:sorts]
        @fullcontact = params[:landscape]
      
        if @timeframe == "Last Year"
          @donors.each do |donor|
            @last_gift = last_gift_by_donation_date(donor)
            if (@last_gift.donation_date.year < Time.currentYear && @last_gift.year > (Time.currentYear - 1))
              @reportDonorsArray.push(donor)
            end
          end
        end
        
        if @timeframe == "Last 2 Years"
          @donors.each do |donor|
            @last_gift = last_gift_by_donation_date(donor)
            if (@last_gift.donation_date.year < Time.currentYear && @last_gift.year > (Time.currentYear - 2))
              @reportDonorsArray.push(donor)
            end
          end
        end
        
        if @timeframe == "All previous years"
          @donors.each do |donor|
            @last_gift = last_gift_by_donation_date(donor)
            if (@last_gift.donation_date.year < Time.currentYear)
              @reportDonorsArray.push(donor)
            end
          end
        end
    end
        
        
      #apply sortby filter
      case @sortby
        when 'Last Name'
          @reportDonorsArray.sort! { |a,b| a.last_name.downcase <=> b.last_name.downcase }
        when 'First Name'
          @reportDonorsArray.sort! { |a,b| a.first_name.downcase <=> b.first_name.downcase }
        when 'Email'
          @reportDonorsArray.sort! { |a,b| a.email <=> b.email }
        when 'State'
          @reportDonorsArray.sort! { |a,b| a.state <=> b.state }
        when 'Date of Last Gift'
          #title field of donor is used to store last gift date. sort these
          @reportDonorsArray.sort! { |b,a| a.title <=> b.title }
        when 'Gift Total'
          #nickname field of donor is used to store last gift date. sort these
          @reportDonorsArray.sort! { |b,a| a.nickname.to_i <=> b.nickname.to_i }
      end
      
      #generate the pdf file for the report
      #landscape donors report will be the full contact report
      if @fullcontact
        pdf = ContactPdf.new(@reportDonorsArray, @timeframe, @sortby)
        send_data pdf.render, :filename => 'LYBUNT Full Contact Report' + " "  + 
        Time.now.to_date.to_s + '.pdf', 
        :type => 'application/pdf', :disposition => 'attachment'
      else
        #portrait donors report will be the normal basic donors report
        pdf = DonorPdf.new(@reportDonorsArray, @timeframe, @sortby, 
        @donorGiftsTotal)
        send_data pdf.render, :filename => 'LYBUNT Report' + " "  + 
        Time.now.to_date.to_s + '.pdf', 
        :type => 'application/pdf', :disposition => 'attachment'
      end
    end
  
  
  private
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  
    #methods for timeframe filters for reports
  
    #returns the quarter that the given date is in
    def current_quarter_months(date)
      quarters = [1,2,3,4]
      quarters[(date.month - 1) / 3]
    end
    
    #returns true/false based on if given date is within the current year
    def is_current_year(date)
      currentYear = currentYear = Time.now.year.to_s
      dateYear = date.strftime('%Y')
      return dateYear.between?(currentYear, currentYear)
    end
    
    #returns true/false based on if given date is within the current quarter
    def is_current_quarter(date)
      currentQuarter = ((Time.now.month - 1) / 3) + 1
      dateQuarter = current_quarter_months(date)
      dateQuarter.between?(currentQuarter, currentQuarter)
    end
    
    #returns true/false based on if given date is within the current month
    def is_current_month(date)
      currentMonth = Time.now.month
      dateMonth = date.month
      dateMonth.between?(currentMonth, currentMonth)
    end
    
    #returns true/false based on if given date is within the previous year
    def is_last_year(date)
      lastYear = (Time.now.year - 1).to_s
      dateYear = date.strftime('%Y')
      return dateYear.between?(lastYear, lastYear)
    end
    
    #returns true/false based on if given date is within the previous quarter
    def is_last_quarter(date)
      lastQuarter = ((Time.now.month - 1) / 3)
      if lastQuarter == 0 
        lastQuarter = 4
      end
      dateQuarter = current_quarter_months(date)
      if (dateQuarter == 4) and (lastQuarter == 4)
        is_last_year(date)
      else
        (dateQuarter.between?(lastQuarter, lastQuarter)) and
        (is_current_year(date))
      end
    end
    
    #returns true/false based on if given date is within the previous month
    def is_last_month(date)
      lastMonth = Time.now.month - 1
      if lastMonth == 0
        lastMonth = 12
      end
      dateMonth = date.month
      if (dateMonth == 12) and (lastMonth == 12)
        is_last_year(date)
      else
        (dateMonth.between?(lastMonth, lastMonth)) and
        (is_current_year(date))
      end
    end
    
    #returns true/false based on if given date is within the previous 5 years
    #this is non-inclusive, so it counts the current year & the previous 4 only.
    def is_past_5_years(date)
      fiveYearsAgo = (Time.now.year - 4).to_s
      dateYear = date.strftime('%Y')
      dateYear.between?(fiveYearsAgo, Time.now.year.to_s)
    end
  
    #returns true/false based on if given date is within the previous 3 months
    def is_past_3_months(date)
      #http://stackoverflow.com/questions/9428605
      monthDifference = (Time.now.year * 12 + Time.now.month) - (date.year * 12 + date.month)
      monthDifference.between?(0, 2)
    end
  
    #returns true/false based on if given date is within the previous 6 months
    def is_past_6_months(date)
      monthDifference = (Time.now.year * 12 + Time.now.month) - (date.year * 12 + date.month)
      monthDifference.between?(0, 5)
    end
    
    
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  
    #methods for finding last gifts from donors
    
    #returns the last gift that a donor made, by created_at date
  def find_last_gift(donor)
    selected_gifts = Gift.where(:donor_id => donor)
    last_gift = nil
    selected_gifts.each do |g|
      if last_gift.nil?
        last_gift = g
      else
        if g.created_at > last_gift.created_at
          last_gift = g
        end
      end
    end 
    return last_gift
  end
  
end
