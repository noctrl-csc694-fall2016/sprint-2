class ActivitiesController < ApplicationController
  #----------------------------------#
  # GiftGarden Activities Controller
  # original written by: Wei H, Oct 15 2016
  # major contributions by:
  #
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
     @activities = Activity.paginate(page: params[:page], per_page: 5)		
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
    Trash.create(:category => "activity", :content => Activity.find(params[:id]).inspect)
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
