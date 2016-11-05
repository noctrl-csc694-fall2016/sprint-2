#----------------------------------#
# Activities Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get all_activities" do
    get activities_path
    assert_response :success
    assert_select "title", "Surf Activities | Gift Garden"
  end
  
  test "should get new_activity" do
    get new_activity_path
    assert_response :success
    assert_select "title", "New Activity | Gift Garden"
  end

end
