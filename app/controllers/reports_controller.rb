class ReportsController < ApplicationController
  
  def activities_setup
    @activities = Activity.all
  end
  
  #handles requests for reports of activities
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
  
  #source: http://stackoverflow.com/questions/8414767/
  def current_quarter_months(date)
    quarters = [[1,2,3], [4,5,6], [7,8,9], [10,11,12]]
    quarters[(date.month - 1) / 3]
  end
  
  def donors_setup
  end
  
  #handles requests for reports of donors
  def donors_report
    respond_to do |format|
      format.html
      @donors = Donor.all
      @reportDonorsArray = []
      # filter out donors based on the parameters put in the form
      @timeframe = params[:times]
      @sortby = params[:sorts]
      @topn = params[:topn]
      @layout = params[:layout]
      
      @donors.each do |donor|
          case @timeframe
          #based on donation_date!
          when 'All'
            @reportDonorsArray.push(donor)
          when 'This Year'
            
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
          
      pdf = DonorPdf.new(@reportDonorsArray, @timeframe, @sortby, @topn)
      send_data pdf.render, :filename => 'Donors Report' + " "  + 
        Time.now.to_date.to_s + '.pdf', 
      :type => 'application/pdf', :disposition => 'attachment'
    end
  end

  def gifts_setup
    @activities = Activity.all
  end
  
  #handles requests for reports of gifts
  def gifts_report
    respond_to do |format|
      format.html
        @gifts = Gift.all
        @reportGiftsArray = []  #re-implement after filters testing is done!!!!!!!!!!!!
        # filter out donors based on the parameters put in the form
        @activity = params[:activity]
        @topn = params[:topn]
        @timeframe = params[:times]
        @sortby = params[:sorts]
        @layout = params[:layout]
        
        #first grab all gifts from the chosen activity
        @activityGiftsArray = []
        @gifts.each do |gift|
          if (gift['activity_id'].to_s) == (@activity['id'].to_s)
            @activityGiftsArray.push(gift)
          end
        end
        
        #then apply the timeframe filter
        @activityGiftsArray.each do |gift|
          case @timeframe
          when 'All'
            @gifts.push(gift)
          when 'This Year'
            if is_current_year(gift['donation_date'])
              @gifts.push(gift)  
            end
          when 'This Quarter'
            if ((is_current_quarter(gift['donation_date'].to_datetime)) && 
              (is_current_year(gift['donation_date'].to_datetime)))
              @gifts.push(gift)  
            end
          when 'This Month'
            if ((is_current_month(gift['donation_date'].to_datetime)) && 
              (is_current_year(gift['donation_date'].to_datetime)))
              @gifts.push(gift)  
            end
          when 'Last Year'
            @gifts.push(gift) #not implemented yet!
          when 'Last Quarter'
            @gifts.push(gift) #not implemented yet!
          when 'Last Month'      
            @gifts.push(gift) #not implemented yet!
          when 'Past 2 Years'
            @gifts.push(gift) #not implemented yet!
          when 'Past 5 Years'
            @gifts.push(gift) #not implemented yet!
          when 'Past 2 Quarters'
            @gifts.push(gift) #not implemented yet!
          when 'Past 3 Months'
            @gifts.push(gift) #not implemented yet!
          when 'Past 6 Months'
            @gifts.push(gift) #not implemented yet!
          end
        end
        
        #apply sort
        case @sortby
          when 'Donor'
            @gifts.sort! { |a,b| a.donor_id.downcase <=> b.donor_id.downcase }
          when 'Amount'
            @gifts.sort! { |a,b| a.amount.downcase <=> b.amount.downcase }
          when 'Donation Date'
            @gifts.sort! { |a,b| a.donation_date <=> b.donation_date }
          when 'Gift Type'
            @gifts.sort! { |a,b| a.gift_type <=> b.gift_type }
        end
        
        #apply topn filter
        #case @topn
        #when 'all'
        #when '10'
        #  @gifts = @gifts.first(10)
        #when '20'
        #  @gifts = @gifts.first(20)
        #when '50'
        #  @gifts = @gifts.first(50)
        #when '100'
        #  @gifts = @gifts.first(100)
        #end
        
        #use all @gifts at first to make sure time and top n filters work,
        #then swtich back to @gifts later to keep it to 1 activity
        pdf = GiftPdf.new(@gifts, @timeframe, @sortby)
        send_data pdf.render, :filename => 'Gifts Report' + " "  + 
        Time.now.to_date.to_s + '.pdf', 
        :type => 'application/pdf', :disposition => 'attachment'
    end
  end
  
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
end
