# Load the Rails application.
require_relative 'application'

#for showing the last deploy datetime on the about page
require File.dirname(__FILE__) + '/../config/environment.rb'
puts Rails.root

# Initialize the Rails application.
Rails.application.initialize!
