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
  test "should get activities" do
    get  report_activities_path
    assert_select "title", "Activities Report | Gift Garden"
    assert_response :success
  end

  test "should get donors" do
    get report_donors_path
    assert_response :success
    assert_select "title", "Donors Report | Gift Garden"
  end

  test "should get gifts" do
    get report_gifts_path
    assert_response :success
    assert_select "title", "Gifts Report | Gift Garden"
  end
  
  #test "should get recurring activities" do
  #  get report_gifts_path
  #  assert_response :success
  #  assert_select "title", "Recurring Activities Report | Gift Garden"
  #end
  
  test "should get trashes" do
    get trashes_path
    assert_response :success
    assert_select "title", "Trash Report | Gift Garden"
  end

#----------------------------------#
# Exotic Reports
#----------------------------------#  
  #test "should get lybunt" do
  #  get report_gifts_path
  #  assert_response :success
  #  assert_select "title", "LYBUNT Report | Gift Garden"
  #end
  
  #test "should get new donors report" do
  #  get report_gifts_path
  #  assert_response :success
  #  assert_select "title", "New Donors Report | Gift Garden"
  #end
  
  test "should get one donors report" do
    get report_one_donor_path
    assert_response :success
    assert_select "title", "One Donor Report | Gift Garden"
  end
  
  #test "should get in kind report" do
  #  get report_gifts_path
  #  assert_response :success
  #  assert_select "title", "In Kind Report | Gift Garden"
  #end
  
  #test "should get blue report" do
  #  get report_gifts_path
  #  assert_response :success
  #  assert_select "title", "Blue Report | Gift Garden"
  #end
  
end
