#----------------------------------#
# Static Pages Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get_root_path' do
    get root_path
    assert_response :success
    assert_select "title", "Home | Gift Garden"
  end
  
  test "should get home" do
    get home_path
    assert_response :success
    assert_select "title", "Home | Gift Garden"
  end

  test "should get_help_path" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Gift Garden"
  end
  
  test "should get_about_path" do
    get about_path
    assert_response :success
    assert_select "title", "About | Gift Garden"
  end
  
  test "should get_contact_path" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | Gift Garden"
  end
  
  test "should get_reports_path" do
    get reports_path
    assert_response :success
    assert_select "title", "Reports | Gift Garden"
  end

end
