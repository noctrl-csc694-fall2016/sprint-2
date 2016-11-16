  #----------------------------------#
  # Static Pages Controller
  # original written by: Jason K, Oct 17 2016
  # major contributions by:
  #
  #----------------------------------#
  
class StaticPagesController < ApplicationController
  #users must be logged into access any of this controller's methods/views
  before_action :logged_in, except: [:about, :help]
  
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
