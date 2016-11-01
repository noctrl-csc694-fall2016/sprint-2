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
            #activity["start_date"] = activity["start_date"]
            @reportActivitiesArray.push(activity)
          when 'This Year'
            #startYear = activity["start_date"].to_datetime.strftime('%Y')
            endYear = activity["end_date"].to_datetime.strftime('%Y')
            currentYear = Time.now.year.to_s
            if endYear.between?(currentYear, currentYear)
              @reportActivitiesArray.push(activity)
            end # (Pat M) Q: do activities that haven't ended have a blank end date?
          when 'This Quarter'
            currentQuarter = ((Time.now.month - 1) / 3) + 1
            monthEnded = activity["end_date"].to_datetime.strftime('%m')
            monthQuarter = ((monthEnded.to_f - 1) / 3) + 1
            #if monthQuarter = currentQuarter
              
              activity["name"] = currentQuarter
              activity["goal"] = monthQuarter
              
              @reportActivitiesArray.push(activity)
            #end
          when 'This Month'
            @reportActivitiesArray.push(activity) #not implemented yet!
          when 'Last Year'
            @reportActivitiesArray.push(activity) #not implemented yet!
          when 'Last Quarter'
            @reportActivitiesArray.push(activity) #not implemented yet!
          when 'Last Month'      
            @reportActivitiesArray.push(activity) #not implemented yet!
          when 'Past 2 Years'
            @reportActivitiesArray.push(activity) #not implemented yet!
          when 'Past 5 Years'
            @reportActivitiesArray.push(activity) #not implemented yet!
          when 'Past 2 Quarters'
            @reportActivitiesArray.push(activity) #not implemented yet!
          when 'Past 3 Months'
            @reportActivitiesArray.push(activity) #not implemented yet!
          when 'Past 6 Months'
            @reportActivitiesArray.push(activity) #not implemented yet!
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
        
        @orientation = :portrait
        case @layout
        when 'landscape'
          @orientation = :landscape  
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
  
end
