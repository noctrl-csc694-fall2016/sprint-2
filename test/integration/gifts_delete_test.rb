require 'test_helper'

class GiftsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @gift = gifts(:one)
  end
  
  test "delete gift" do
    get edit_gift_path(@gift)
    assert_select 'a', text: 'Delete Gift'
    assert_difference 'Gift.count', -1 do
      delete gift_path(@gift)
    end
    assert_response :redirect
    assert_redirected_to gifts_path(activity_id: "", donor_id: "")
  end
  
end