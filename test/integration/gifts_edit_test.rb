#----------------------------------#
# Gifts Edit Integration Test
# original written by: 
# major contributions by: Wei H, Andy W, Jason K
#
#----------------------------------#
require 'test_helper'

class GiftsEditTest < ActionDispatch::IntegrationTest
  def setup
    @gift = gifts(:one)
    @donor = donors(:andy)
    @activity = activities(:golf)
    @donor2 = donors(:bob)
    @activity2 = activities(:food)
  end
  
  test "successful gift edit" do
    get edit_gift_path(@gift)
    assert_template 'gifts/edit'
    donor_id = @donor2.id
    activity_id = @activity2.id
    donation_date = "2016-10-24"
    amount = 30
    gift_type = "Check"
    patch gift_path(@gift), params: { gift: { donor_id:  donor_id,
                                                activity_id: activity_id,
                                                donation_date: donation_date,
                                                amount: amount,
                                                gift_type: gift_type } }
    assert_redirected_to gifts_path(:donor_id =>donor_id, :activity_id => activity_id)
    @gift.reload
    assert_equal donor_id, @gift.donor_id
    assert_equal activity_id, @gift.activity_id
    assert_equal amount, @gift.amount
    assert_equal donation_date, @gift.donation_date.to_s
    assert_equal gift_type, @gift.gift_type
  end

  test "unsuccessful edit" do
    get edit_gift_path(@gift)
    assert_template 'gifts/edit'
    patch gift_path(@gift), params: { gift: { donor_id:  @donor.id,
                                                activity_id: @activity.id,
                                                donation_date: "",
                                                amount: 2000.00,
                                                gift_type: "",
                                                notes: "No date or type" } }

    assert_template 'gifts/edit'
    assert_select "div.alert", true
  end
end
