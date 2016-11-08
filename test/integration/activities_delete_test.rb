require 'test_helper'

class ActivitiesDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @activity_y = activities(:golf) # activity with gift
    @activity_n = activities(:food) # activity with no gift
  end
  
  test "delete activity with and without gift" do
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
  
  test "Trash generated when an activity with no gift is deleted" do
    get edit_activity_path(@activity_n)
    assert_difference 'Trash.count', 1 do
      delete activity_path(@activity_n)
    end
    assert_response :redirect
    assert_redirected_to activities_path
  end

end