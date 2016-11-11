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
  test "layout links" do
    get home_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", home_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", new_gift_path
    #assert_select "a[href=?]", activities_path
    assert_select "a[href=?]", reports_path
    assert_select "a[href=?]", import_export_path
  end
end
