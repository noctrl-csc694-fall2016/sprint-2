#----------------------------------#
# Donors Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#                     Andy W Nov 14 2016
#----------------------------------#
require 'test_helper'

class DonorsControllerTest < ActionDispatch::IntegrationTest
  test "should_get_all_donors_with_params" do
    @user = users(:michael)
    log_in_as(@user)
    get donors_path + "?utf8=%E2%9C%93&timeframe=All&sortby=&pageby=&commit=GO"
    assert_response :success
    assert_select "title", "Surf Donors | Gift Garden"
  end
  
  test "should_get_new_donor_page" do
    @user = users(:michael)
    log_in_as(@user)
    get new_donor_path
    assert_response :success
    assert_select "title", "New Donor | Gift Garden"
  end


end
