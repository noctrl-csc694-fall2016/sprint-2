#----------------------------------#
# Donors Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class DonorsControllerTest < ActionDispatch::IntegrationTest
  test "should get all_donors" do
    get donors_path
    assert_response :success
    assert_select "title", "Surf Donors | Gift Garden"
  end
  
  test "should get new donor page" do
    get new_donor_path
    assert_response :success
    assert_select "title", "New Donor | Gift Garden"
  end


end
