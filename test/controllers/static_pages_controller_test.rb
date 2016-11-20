#----------------------------------#
# Static Pages Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should_get_root_path' do
    get root_path
    assert_response :success
    assert_select "title", "Log In | Gift Garden"
  end
  
  test "should_get_home_when_logged_in" do
    @user = users(:michael)
    log_in_as(@user)
    get home_path
    assert_response :success
    assert_select "title", "Home | Gift Garden"
  end

  test "should_get_help_path" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Gift Garden"
  end
  
  test "should_get_about_path" do
    get about_path
    assert_response :success
    assert_select "title", "About | Gift Garden"
  end

  test "should_get_reports_path_when_logged_in" do
    @user = users(:michael)
    log_in_as(@user)
    get reports_path
    assert_response :success
    assert_select "title", "Reports | Gift Garden"
  end

end
