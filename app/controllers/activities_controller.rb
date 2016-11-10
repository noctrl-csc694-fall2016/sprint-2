class ActivitiesController < ApplicationController
  #----------------------------------#
  # GiftGarden Activities Controller
  # original written by: Wei H, Oct 15 2016
  # major contributions by:
  #                     Pat M Oct 26 2016
  #                     Andy W Nov 7 2016
  #----------------------------------#
  
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
      flash[:success] = "Activity added successfully!"
      redirect_to activities_url
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
    
    #select the TOP N activities, ordered by goal amount
    if(params[:topn] != "" && params[:topn] != "All")
      @selected_activities = @selected_activities.reorder("goal DESC")
      @activity_ids = @selected_activities.select("id").limit(params[:topn].to_i)
      @selected_activities = @selected_activities.where(id: @activity_ids)
    end
    
    #sort results (reorder objects in table)
    case params[:sortby]
      when 'Name'
        @selected_activities = @selected_activities.reorder("name")
      when 'Start Date'
        @selected_activities = @selected_activities.reorder("start_date DESC")
      when 'End Date'
        @selected_activities = @selected_activities.reorder("end_date DESC")
      when 'Goal'
        @selected_activities = @selected_activities.reorder("goal DESC")
    end
    
    #paginate selected activities list after sorting & filtering
     @selected_activities = @selected_activities.paginate(page: params[:page], per_page: 5)		
     
     
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
