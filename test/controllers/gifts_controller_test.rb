#----------------------------------#
# Gifts Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#                       Andy W Nov 14 2016
#                       Pat M Nov 20 2016
#----------------------------------#
require 'test_helper'

class GiftsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @gift = gifts(:one)
  end


  test "should_get_all_gifts_with_params" do
    @user = users(:michael)
    log_in_as(@user)
    get gifts_path + "?utf8=%E2%9C%93&activity_id=&donor_id=&timeframe=All&sortby=&pageby=&commit=GO"
    assert_response :success
    assert_select "title", "Surf Gifts | Gift Garden"
  end
  
  test "should_get_new_gift" do
    @user = users(:michael)
    log_in_as(@user)
    get new_gift_path
    assert_response :success
    assert_select "title", "New Gift | Gift Garden"
  end

  test "should redirect create gift when not logged in" do
    assert_no_difference 'Gift.count' do
      post gifts_path, params: { gift: {   donor: 'andy',
        activity: 'golf',
        donation_date: '2016-10-12 18:40:46',
        amount: 1500.00,
        gift_type: 'cash' } }
    end
    assert_redirected_to login_url
  end

  test "should redirect delete gift when not logged in" do
    assert_no_difference 'Gift.count' do
      delete gift_path(@gift)
    end
    assert_redirected_to login_url
  end
  
  #makes sure that users not logged in can't access the gifts surf
  test "should redirect gifts surf when not logged in" do
    get gifts_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  #makes sure that users not logged in can't access new gift page
  test "should redirect new gift when not logged in" do
    get new_gift_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  #makes sure that users not logged in can't access edit gift page
  test "should redirect edit gift when not logged in" do
    get '/gifts/1/edit'
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
