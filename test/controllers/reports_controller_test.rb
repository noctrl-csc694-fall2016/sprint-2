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
  test "should get activities report" do
    @user = users(:michael)
    log_in_as(@user)
    get  report_activities_path
    assert_select "title", "Activities Report | Gift Garden"
    assert_response :success
  end

  test "should get donors report" do
    @user = users(:michael)
    log_in_as(@user)
    get report_donors_path
    assert_response :success
    assert_select "title", "Donors Report | Gift Garden"
  end

  test "should get gifts report" do
    @user = users(:michael)
    log_in_as(@user)
    get report_gifts_path
    assert_response :success
    assert_select "title", "Gifts Report | Gift Garden"
  end
  
  test "should get trashes report" do
    @user = users(:michael)
    log_in_as(@user)
    get trashes_path
    assert_response :success
    assert_select "title", "Trash Report | Gift Garden"
  end

#----------------------------------#
# Exotic Reports
#----------------------------------#  
  test "should get one donors report" do
    @user = users(:michael)
    log_in_as(@user)
    get report_one_donor_path
    assert_response :success
    assert_select "title", "One Donor Report | Gift Garden"
  end
  
  test "should get lybunt report" do
    @user = users(:michael)
    log_in_as(@user)
    get report_lybunt_path
    assert_response :success
    assert_select "title", "LYBUNT Report | Gift Garden"
  end
  
end
