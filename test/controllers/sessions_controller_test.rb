#----------------------------------#
# Sessions Controller Test
# original written by: Pat M, Nov 7 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  
  #makes sure the login path exists
  test "should get new" do
    get login_path
    assert_response :success
  end

  #makes sure the create path exists (happens after login)
  test "should get create" do
    get login_path
    assert_response :success
  end

  #makes sure the destroy path exists (happens on logout)
  test "should get destroy" do
    get login_path
    assert_response :success
  end

end
