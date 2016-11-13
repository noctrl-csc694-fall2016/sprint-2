  #----------------------------------#
  # GiftGarden Test Helper Test
  # original written by: Jason K, Nov 13, 2016
  # major contributions by:
  #
  #
  # Referenced from sample_app of tutorial
  #----------------------------------#
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  # Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest

  # Log in as a particular user.
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { username: user.username,
                                          password: password,
                                          } }
  end
end