class ReportsController < ApplicationController
  
  def activities_setup
    @activities = Activity.all
  end
  
  def activities_report
    #Activity.report(params[:file], params[:activity])
    #redirect_to reports_url, notice: "Activities Report Created."
  end
  
  def donors_setup
  end
  
  def donors_report
  end

  def gifts_setup
    @activities = Activity.all
  end
  
  def gifts_report
  end
  
end
