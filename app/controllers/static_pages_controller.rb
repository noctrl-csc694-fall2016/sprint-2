  #----------------------------------#
  # Static Pages Controller
  # original written by: Jason K, Oct 17 2016
  # major contributions by:
  #
  #----------------------------------#
  
class StaticPagesController < ApplicationController
  def home
  end

  def about
  end

  def help
  end
  
  def contact
  end
  
  def reports
    @activities = Activity.all
  end
  
  def import_export
    @activities = Activity.all
  end
end
