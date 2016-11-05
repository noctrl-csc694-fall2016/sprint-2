#----------------------------------#
# Reports Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get activities" do
    get  report_activities_path
    assert_response :success
  end

  test "should get donors" do
    get report_donors_path
    assert_response :success
  end

  test "should get gifts" do
    get report_gifts_path
    assert_response :success
  end
  
  #test "should get recurring activities" do
  #  get report_gifts_path
  #  assert_response :success
  #end
  
  #test "should get lybunt" do
  #  get report_gifts_path
  #  assert_response :success
  #end

end
