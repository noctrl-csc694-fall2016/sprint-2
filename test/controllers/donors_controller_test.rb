#----------------------------------#
# Donors Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#                     Andy W Nov 14 2016
#----------------------------------#
require 'test_helper'

class DonorsControllerTest < ActionDispatch::IntegrationTest
  test "should get all donors with params" do
    get donors_path + "?utf8=%E2%9C%93&timeframe=All&sortby=&pageby=&commit=GO"
    assert_response :success
    assert_select "title", "Surf Donors | Gift Garden"
  end
  
  test "should get new donor page" do
    get new_donor_path
    assert_response :success
    assert_select "title", "New Donor | Gift Garden"
  end


end
