#----------------------------------#
# Activities Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#                     Andy W Nov 14 2016
#                     Pat M Nov 20 2016
#----------------------------------#
require 'test_helper'

def setup
  @activity = activites(:food)
end

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should_get_all_activities_with_params" do
    @user = users(:michael)
    log_in_as(@user)
    get activities_path + "?utf8=%E2%9C%93&timeframe=All&sortby=&pageby=&commit=GO"
    assert_response :success
    assert_select "title", "Surf Activities | Gift Garden"
  end
  
  test "should_get_new_activity" do
    @user = users(:michael)
    log_in_as(@user)
    get new_activity_path
    assert_response :success
    assert_select "title", "New Activity | Gift Garden"
  end

  #makes sure that users not logged in can't access the activity surf
  test "should redirect activites surf when not logged in" do
    get activities_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  #makes sure that users not logged in can't access new activity page
  test "should redirect new activity when not logged in" do
    get new_activity_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  #makes sure that users not logged in can't access edit activity page
  test "should redirect edit activity when not logged in" do
    get '/activities/1/edit'
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
