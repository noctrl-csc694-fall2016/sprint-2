#----------------------------------#
# Activities Edit Integration Test
# original written by: 
# major contributions by: Wei H, Andy W
#
#----------------------------------#
require 'test_helper'

class ActivitiesEditTest < ActionDispatch::IntegrationTest
  def setup
    @activity = activities(:golf)
    @user = users(:michael)
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_activity_path(@activity)
    assert_template 'activities/edit'
    name = "Food Truck"
    start_date = "2016-07-16"
    end_date = "2016-07-16"
    description = "new description"
    goal = 1000
    notes = "new notes"
    patch activity_path(@activity), params: {activity: {name: name,
                                                        start_date: start_date,
                                                        end_date: end_date,
                                                        description: description,
                                                        goal: goal,
                                                        notes: notes} }
    assert_redirected_to activities_path
    @activity.reload
    assert_equal name, @activity.name
    assert_equal start_date.to_s, @activity.start_date.to_s
    assert_equal end_date.to_s, @activity.end_date.to_s
    assert_equal description, @activity.description
    assert_equal goal, @activity.goal
    assert_equal notes, @activity.notes
  end
  
  test "unsuccessful edit " do
    log_in_as(@user)
    get edit_activity_path(@activity)
    assert_template 'activities/edit'
    patch activity_path(@activity), params: { activity: { name: "",
                                                          start_date: "",
                                                          end_date: "",
                                                          description: "",
                                                          goal: "number" } }
    assert_template 'activities/edit'
    assert_select "div.alert", true
  end
  
end