class ApplicationController < ActionController::Base
  before_filter :app_last_updated_at
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # Include the CSV module for CSV output.  Source: https://www.lockyy.com/posts/rails-4/exporting-csv-files-in-rails
  # require File.expand_path('../boot', __FILE__)
  require 'csv'
  require 'rails/all'

  def hello
    render html: "hello, world! and Bill says... huzzah to 694...Andy was here! JK shuffles the deck. Mke D finishes it! Wei H...."
  end
  
  private
  #retrieves the last deploy datetime for the about page.
  #source: http://stackoverflow.com/questions/2700964/
  def app_last_updated_at
    if File.exist?(Rails.root + "/REVISION")
      timezone = "Central Time (US & Canada)"
      @app_last_updated_at = File.atime(Rails.root + "/REVISION").in_time_zone( timezone )
    else
      @app_last_updated_at = ""
    end
  end
end
