class ReportsController < ApplicationController
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # Setup Activities Report View
  def activities_setup
    @activities = Activity.all
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # Basic Activities Report
  def activities_report
    #Activity.report(params[:file], params[:activity])
    respond_to do |format|
      format.html
        @activities = Activity.all
        @reportActivitiesArray = []
        # filter out activities based on the parameters put in the form
        @timeframe = params[:timeframe]
        @sortby = params[:sortby]
        @layout = params[:layout]
        
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
        
        case @sortby
          when 'Name'
            @reportActivitiesArray.sort! { |a,b| a.name.downcase <=> b.name.downcase }
            #@reportActivitiesArray.sort_by(Activity.name) #test line for breaking to see params
          when 'Start Date'
            @reportActivitiesArray.sort! { |b,a| a.start_date <=> b.start_date }
          when 'End Date'
            @reportActivitiesArray.sort! { |b,a| a.end_date <=> b.end_date }
          when 'Goal'
            @reportActivitiesArray.sort! { |b,a| a.goal <=> b.goal }
        end
        
        pdf = ActivityPdf.new(@reportActivitiesArray, @timeframe, @sortby)
        send_data pdf.render, :filename => 'Activity Report' + " " + Time.now.to_date.to_s + '.pdf', 
        :type => 'application/pdf', :disposition => 'attachment', :page_layout => :landscape
    end
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # Setup Donors Report View
  def donors_setup
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # Basic Donors Report
  def donors_report
    respond_to do |format|
      format.html
      @donors = Donor.all
      @gifts = Gift.all
      @reportDonorsArray = []
      @donorGiftLatestDate = '1900-01-01'.to_date
      @donorGiftsTotals = []
      
      @timeframe = params[:times]
      @sortby = params[:sorts]
      @topn = params[:topn]
      @layout = params[:layout]
      
      @donors.each do |donor|
        
        #flag for if a donor had a gift during the timeframe
        applicable = 1
        giftsTotal = 0
        
        case @timeframe
        #based on donation_date!
        when 'All'
          # should this include donors with NO gifts?
          @reportDonorsArray.push(donor)
        when 'This Year'
          
          @gifts.each do |g|
            if g.donor_id.eql? donor['id'] #belongs to this donor
              if is_current_year(g['donation_date'].to_datetime) #in timeframe
                applicable++ #OK to add this donor
                giftsTotal += g['amount'] #include in total gifts amount
              end #end is_current_year
            end #end if donor's gift
          end #end gift loop
          
          add_donor_and_gifts_as_needed(applicable, donor, giftsTotal)
        when 'This Quarter'
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'This Month'
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'Last Year'
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'Last Quarter'
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'Last Month'      
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'Past 2 Years'
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'Past 5 Years'
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'Past 2 Quarters'
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'Past 3 Months'
          @reportDonorsArray.push(donor) #not implemented yet!
        when 'Past 6 Months'
          @reportDonorsArray.push(donor) #not implemented yet!
        end
      end
        
        case @sortby
          when 'Last Name'
            @reportDonorsArray.sort! { |a,b| a.last_name.downcase <=> b.last_name.downcase }
          when 'First Name'
            @reportDonorsArray.sort! { |a,b| a.first_name.downcase <=> b.first_name.downcase }
          when 'Email'
            @reportDonorsArray.sort! { |a,b| a.email <=> b.email }
          when 'State'
            @reportDonorsArray.sort! { |a,b| a.state <=> b.state }
        end
        
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
          
      pdf = DonorPdf.new(@reportDonorsArray, @timeframe, @sortby, @topn, 
      @donorGiftsTotals)
      send_data pdf.render, :filename => 'Donors Report' + " "  + 
        Time.now.to_date.to_s + '.pdf', 
      :type => 'application/pdf', :disposition => 'attachment'
    end
  end
  
  def add_donor_and_gifts_as_needed(count, donor, total)
    if count > 0
      @reportDonorsArray.push(donor)
    end
    if total > 0
      @donorGiftsTotals.push(total.to_s)
    else
      @donorGiftsTotals.push('')
    end
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # Setup Gifts Report View
  def gifts_setup
    @activities = Activity.all
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # Basic Gifts Report
  def gifts_report
    respond_to do |format|
      format.html
        @gifts = Gift.all
        @activities = Activity.all
        @reportGiftsArray = []  
        @activityGiftsArray = []
        @activity = params[:activity]
        @topn = params[:topn]
        @timeframe = params[:times]
        @sortby = params[:sorts]
        @layout = params[:layout]
        
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
          when 'Donor ID'
            @reportGiftsArray.sort! { |b,a| a.donor_id.to_s <=> b.donor_id.to_s }
          when 'Amount'
            @reportGiftsArray.sort! { |a,b| a.amount.to_s <=> b.amount.to_s }
          when 'Donation Date'
            @reportGiftsArray.sort! { |a,b| a.donation_date <=> b.donation_date }
          when 'Gift Type'
            @reportGiftsArray.sort! { |a,b| a.gift_type <=> b.gift_type }
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
        pdf = GiftPdf.new(@reportGiftsArray, @timeframe, @sortby)
        send_data pdf.render, :filename => 'Gifts Report' + " "  + 
        Time.now.to_date.to_s + '.pdf', 
        :type => 'application/pdf', :disposition => 'attachment'
    end
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # Methods for timeframe filters for reports

  def current_quarter_months(date)
    quarters = [1,2,3,4]
    quarters[(date.month - 1) / 3]
  end
  
  def is_current_year(date)
    currentYear = currentYear = Time.now.year.to_s
    dateYear = date.strftime('%Y')
    return dateYear.between?(currentYear, currentYear)
  end
  
  def is_current_quarter(date)
    currentQuarter = ((Time.now.month - 1) / 3) + 1
    dateQuarter = current_quarter_months(date)
    dateQuarter.between?(currentQuarter, currentQuarter)
  end
  
  def is_current_month(date)
    currentMonth = Time.now.month
    dateMonth = date.month
    dateMonth.between?(currentMonth, currentMonth)
  end
  
  def is_last_year(date)
    lastYear = (Time.now.year - 1).to_s
    dateYear = date.strftime('%Y')
    return dateYear.between?(lastYear, lastYear)
  end
  
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
  
  #non-inclusive
  def is_past_5_years(date)
    fiveYearsAgo = (Time.now.year - 4).to_s
    dateYear = date.strftime('%Y')
    dateYear.between?(fiveYearsAgo, Time.now.year.to_s)
  end

  def is_past_3_months(date)
    #http://stackoverflow.com/questions/9428605
    monthDifference = (Time.now.year * 12 + Time.now.month) - (date.year * 12 + date.month)
    monthDifference.between?(0, 2)
  end

  def is_past_6_months(date)
    monthDifference = (Time.now.year * 12 + Time.now.month) - (date.year * 12 + date.month)
    monthDifference.between?(0, 5)
  end
  
  #source: http://stackoverflow.com/questions/8414767/
  def current_quarter_months(date)
    quarters = [[1,2,3], [4,5,6], [7,8,9], [10,11,12]]
    quarters[(date.month - 1) / 3]
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  # Trash Report 
  def trash_report
    @trash = Trash.all
    
    respond_to do |format|
      format.html
      format.pdf do
        pdf = TrashPdf.new(@trash)
        send_data pdf.render, filename: 'trashReport.pdf', type: 'application/pdf', :disposition => 'attachment'
      end
    end
  end
  
end
