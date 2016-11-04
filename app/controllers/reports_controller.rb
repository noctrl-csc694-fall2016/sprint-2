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
        send_data pdf.render, :filename => 'Activities Report.pdf', 
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
      @timeframe = params[:times]
      @sortby = params[:sorts]
      @topn = params[:topn]
          pdf = DonorPdf.new(@donors, @timeframe, @sortby, @topn)
          send_data pdf.render, :filename => 'Donors Report.pdf', 
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
        pdf = GiftPdf.new(@gifts)
        send_data pdf.render, :filename => 'Gifts Report.pdf', 
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
  
  def trash_report
    
    
    respond_to do |format|
      format.html
      @trash = Trash.all
      format.pdf do
        pdf = TrashPdf.new(@trash)
        send_data pdf.render, filename: 'trashReport.pdf', type: 'application/pdf', :disposition => 'attachment'
      end
    end
  end
  
end
