#----------------------------------#
# Activities Delete Integration Test
# original written by: Wei H, Nov 7 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class ActivitiesDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @activity_y = activities(:golf) # activity with gift
    @activity_n = activities(:food) # activity with no gift
    @user = users(:michael)
  end
  
  test "delete activity with and without gift" do
    log_in_as(@user)
    get edit_activity_path(@activity_y)
    assert_select "a", {count: 0, text: "Delete Activity"}
    get edit_activity_path(@activity_n)
    assert_select "a", text: "Delete Activity"
    assert_difference 'Activity.count', -1 do
      delete activity_path(@activity_n)
    end
    assert_response :redirect
    assert_redirected_to activities_path
  end
  
  test "trash generated when an activity with no gift is deleted" do
    log_in_as(@user)
    get edit_activity_path(@activity_n)
    assert_difference 'Trash.count', 1 do
      delete activity_path(@activity_n)
    end
    assert_response :redirect
    assert_redirected_to activities_path
  end

end