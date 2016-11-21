#----------------------------------#
# Gifts Delete Integration Test
# original written by: Wei H, Nov 7 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class GiftsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @gift = gifts(:one)
    @user = users(:michael)
  end
  
  test "delete gift" do
    log_in_as(@user)
    get edit_gift_path(@gift)
    assert_select 'a', text: 'Delete Gift'
    assert_difference 'Gift.count', -1 do
      delete gift_path(@gift)
    end
    assert_response :redirect
    assert_redirected_to gifts_path(activity_id: "", donor_id: "")
  end
  
  test "trash generated when a gift is deleted" do
    log_in_as(@user)
    get edit_gift_path(@gift)
    assert_difference 'Trash.count', 1 do
      delete gift_path(@gift)
    end
    assert_response :redirect
    assert_redirected_to gifts_path(activity_id: "", donor_id: "")
  end
  
end