#----------------------------------#
# Gifts Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#                       Andy W Nov 14 2016
#----------------------------------#
require 'test_helper'

class GiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get all_gifts with params" do
    get gifts_path + "?utf8=%E2%9C%93&activity_id=&donor_id=&timeframe=All&sortby=&pageby=&commit=GO"
    assert_response :success
    assert_select "title", "Surf Gifts | Gift Garden"
  end
  
  test "should get new_gift" do
    @user = users(:michael)
    log_in_as(@user)
    get new_gift_path
    assert_response :success
    assert_select "title", "New Gift | Gift Garden"
  end

  test "should get edit" do
    get donors_edit_url
    assert_response :success
  end

end
