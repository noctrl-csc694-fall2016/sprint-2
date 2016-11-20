#----------------------------------#
# Activities Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#                     Andy W Nov 14 2016
#----------------------------------#
require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get all activities with params" do
    @user = users(:michael)
    log_in_as(@user)
    get activities_path + "?utf8=%E2%9C%93&timeframe=All&sortby=&pageby=&commit=GO"
    assert_response :success
    assert_select "title", "Surf Activities | Gift Garden"
  end
  
  test "should get new activity" do
    @user = users(:michael)
    log_in_as(@user)
    get new_activity_path
    assert_response :success
    assert_select "title", "New Activity | Gift Garden"
  end

end
