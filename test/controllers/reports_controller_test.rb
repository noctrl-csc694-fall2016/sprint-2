#----------------------------------#
# Reports Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
#----------------------------------#
# Standard Reports
#----------------------------------#
  test "should_get_activities_report" do
    @user = users(:michael)
    log_in_as(@user)
    get  report_activities_path
    assert_select "title", "Activities Report | Gift Garden"
    assert_response :success
  end

  test "should_get_donors_report" do
    @user = users(:michael)
    log_in_as(@user)
    get report_donors_path
    assert_response :success
    assert_select "title", "Donors Report | Gift Garden"
  end

  test "should_get_gifts_report" do
    @user = users(:michael)
    log_in_as(@user)
    get report_gifts_path
    assert_response :success
    assert_select "title", "Gifts Report | Gift Garden"
  end
  
  test "should_get_trashes_report" do
    @user = users(:michael)
    log_in_as(@user)
    get trashes_path
    assert_response :success
    assert_select "title", "Trash Report | Gift Garden"
  end

#----------------------------------#
# Exotic Reports
#----------------------------------#  
  test "should_get_one_donors_report" do
    @user = users(:michael)
    log_in_as(@user)
    get report_one_donor_path
    assert_response :success
    assert_select "title", "One Donor Report | Gift Garden"
  end
  
end
