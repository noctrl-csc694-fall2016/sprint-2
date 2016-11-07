class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # Include the CSV module for CSV output.  Source: https://www.lockyy.com/posts/rails-4/exporting-csv-files-in-rails
  # require File.expand_path('../boot', __FILE__)
  require 'csv'
  require 'rails/all'

  def hello
    render html: "hello, world! and Bill says... huzzah to 694...Andy was here! JK shuffles the deck. Mke D finishes it! Wei H...."
  end
end
