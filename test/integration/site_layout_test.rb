  #----------------------------------#
  # GiftGarden Layout Test
  # original written by: Wei H, Oct 15 2016
  # major contributions by:
  #                     Pat M Oct 24 2016
  #                     Andy W Oct 25, 2016
  #                     Jason K Nov 7 2016
  #----------------------------------#
require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  #####################################
  # Test to validate available links when logged in
  #####################################
  test "layout links when logged in" do
    log_in_as(@user) 
    get home_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", home_path, count: 3
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", new_gift_path
    #assert_select "a[href=?]", activities_path
    assert_select "a[href=?]", reports_path
    assert_select "a[href=?]", import_export_path
    assert_select "a[href=?]", logout_path
  end
  
  #####################################
  # Test to validate available links when not logged in
  #####################################
  test "layout links when loggout out" do
    get login_path
    assert_template 'sessions/new'
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", new_gift_path, count: 0
    assert_select "a[href=?]", activities_path, count: 0
    assert_select "a[href=?]", reports_path, count: 0
    assert_select "a[href=?]", import_export_path, count: 0
  end
end
