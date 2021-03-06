class ActivitiesController < ApplicationController
  #----------------------------------#
  # GiftGarden Activities Controller
  # original written by: Wei H, Oct 15 2016
  # major contributions by:
  #                     Pat M Oct 26 2016
  #                     Andy W Nov 7 2016
  #----------------------------------#
  include ActivitiesHelper
  include UsersHelper
  #users must be logged into access any of this controller's methods/views
  before_action :logged_in
  
  # defines a new activity
  def new
    @activity = Activity.new
  end
  
  # find activity by id and populate edit screen
  def edit
    @activity = Activity.find(params[:id])
  end
  
  #create new activity, or render edit page with errors list
  #activity_params defined in private below
  def create
    @activity = Activity.new(activity_params)
    
    if @activity.save
      if (@activity.start_date = Time.now.beginning_of_year && @activity.end_date = DateTime.parse("2099-12-31 00:00:00"))
        flash[:success] = "Activity added successfully!  PLEASE NOTE: Default start and end dates applied."
        redirect_to activities_url
     else
        flash[:success] = "Activity added successfully!"
        redirect_to activities_url
      end
    else
      render 'new'
    end
  end
  
  #update activity, or render edit page with errors list
  def update
    @activity = Activity.find(params[:id])
    if @activity.update(activity_params)
       redirect_to activities_url
       flash[:success] = "Activity updated successfully!"
    else
      render 'edit'
    end
  end
  
  #list all activities on index page		
  def index		
    
    #add all activities to selected_activities
    @selected_activities = Activity.all
    
    #check for all parameters in page call
    if (params.has_key?(:timeframe) && params.has_key?(:sortby) && params.has_key?(:pageby) && params.has_key?(:commit)) == false
      redirect_to activities_url + "?utf8=%E2%9C%93&timeframe=All&sortby=&pageby=&commit=GO"
    end
    
    #TIMEFRAME filtering
    case params[:timeframe]
          when 'All'
          when 'This Year'
            @selected_activities = @selected_activities.where(end_date: Time.current.beginning_of_year..Time.current.end_of_year)
          when 'This Quarter'
            @selected_activities = @selected_activities.where(end_date: Time.current.beginning_of_quarter..Time.current.end_of_quarter)
          when 'This Month'
            @selected_activities = @selected_activities.where(end_date: Time.current.beginning_of_month..Time.current.end_of_month)
          when 'Last Year'
            @start_year = 1.year.ago.beginning_of_year - 1.day
            @end_year = 1.year.ago.end_of_year
            @selected_activities = @selected_activities.where(end_date: @start_year..@end_year)
          when 'Last Quarter'
            @start_quarter = Time.current.beginning_of_quarter - 3.months - 1.day
            @end_quarter = Time.current.end_of_quarter - 3.months
            @selected_activities = @selected_activities.where(end_date: @start_quarter..@end_quarter)
          when 'Last Month'
            @start_month = 1.month.ago.beginning_of_month - 1.day
            @end_month = 1.month.ago.end_of_month
            @selected_activities = @selected_activities.where(end_date: @start_month..@end_month)
          when 'Past 2 Years'
            @selected_activities = @selected_activities.where("end_date >= ?", 2.years.ago.to_date)
          when 'Past 5 Years'
            @selected_activities = @selected_activities.where("end_date >= ?", 5.years.ago.to_date)
          when 'Past 2 Quarters'
            @selected_activities = @selected_activities.where("end_date >= ?", 1.quarter.ago.to_date)
          when 'Past 3 Months'
            @selected_activities = @selected_activities.where("end_date >= ?", 3.months.ago.to_date)
          when 'Past 6 Months'
            @selected_activities = @selected_activities.where("end_date >= ?", 6.months.ago.to_date)
    end
    
    #sort results (reorder objects in table)
    case params[:sortby]
      when 'ID'
        @selected_activities = @selected_activities.reorder("id DESC")
      when 'Name'
        @selected_activities = @selected_activities.reorder("name")
      when 'End Date'
        @selected_activities = @selected_activities.reorder("end_date DESC")
      when 'Progress'
        
        #first build activitiesProgressArray
        @activitiesProgressArray = @selected_activities.to_a
        
        @activitiesProgressArray.each do |act|
              #calculate associated gifts total
              begin
                gifts = Gift.where(:activity_id => act.id)
                gifts.to_a
              rescue ActiveRecord::RecordNotFound
                gifts = nil #if no matches found
              end
              giftTotal = 0
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
            @activitiesProgressArray.sort! { |b,a| a.notes.to_i <=> b.notes.to_i }
            #now store in selected_activities to be printed on page
            @selected_activities = @activitiesProgressArray
    end
    
    #paginate selected activities list after sorting & filtering
    #use selected amount per page
    if(params[:pageby] != "")
      @selected_activities = @selected_activities.paginate(page: params[:page], per_page: params[:pageby])
    else
      @selected_activities = @selected_activities.paginate(page: params[:page], per_page: 10)
    end	
     
     
     respond_to do |format|		
       format.html		
        format.pdf do		
           pdf = ActivityPdf.new(@activities)		
           send_data pdf.render, filename: 'Activities.pdf', type: 'application/pdf'		
        end		
      end		
  end
  
  #delete activity
  def destroy
    Trash.create!(:trash_type => "activity", :content => Activity.find(params[:id]).inspect)
    Activity.find(params[:id]).destroy
    flash[:success] = "Activity deleted."
    redirect_to activities_path
  end
  
  def import
    Activity.import(params[:file])
    redirect_to root_url, notice: "Activities imported."
  end
  
  private
    #define activity parameters accepted and required for create and update methods
    def activity_params
      params.required(:activity).permit(:name, :start_date, :end_date, :description,
       :goal, :notes, :activity_type)
    end
  
end
