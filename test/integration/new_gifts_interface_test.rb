require 'test_helper'

class NewGiftsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @gift = gifts(:one)
    @user = users(:michael)
  end
  
  test "new gift interface" do
    log_in_as(@user)
    get new_gift_path
    # Invalid submission
    assert_no_difference 'Gift.count' do
      post gifts_path, params: { gift: { activity_id: @gift.activity_id, donation_date: @gift.donation_date, gift_type: @gift.gift_type, amount: @gift.amount } }
    end
    
    # Valid submission
    assert_difference 'Gift.count', 1 do
      post gifts_path, params: { gift: { donor_id: @gift.donor_id, activity_id: @gift.activity_id, donation_date: @gift.donation_date, gift_type: @gift.gift_type, amount: @gift.amount } }
    end
    
    assert_redirected_to new_gift_path params: { donor_id: @gift.donor_id, activity_id: @gift.activity_id, donation_date: @gift.donation_date, gift_type: @gift.gift_type, amount: @gift.amount, pledge:0.0 }

  end
end