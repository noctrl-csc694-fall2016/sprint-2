require 'test_helper'

  #----------------------------------#
  # Gift Model Test
  # original written by: Andy W Nov 8 2016
  # major contributions by:
  #             
  #----------------------------------#


class GiftTest < ActiveSupport::TestCase

  def setup
    @gift = gifts(:one)
    @gift2 = gifts(:two)
  end
  
  test "notes should not be too long" do 
    @gift.notes = "a" * 2501
    assert_not @gift.valid?
  end
  
  test "should be valid" do
    assert @gift.valid?
  end

  test "activity id should be present" do
    @gift.activity_id = nil
    assert_not @gift.valid?
  end
  
  test "donor should be present" do
    @gift.donor_id = nil
    assert_not @gift.valid?
  end
  
  test "amount should be present" do
    @gift.amount = nil
    assert_not @gift.valid?
  end

  test "date should be present" do
    @gift.donation_date = nil
    assert_not @gift.valid?
  end
  
  test "type should be present" do
    @gift.gift_type = nil
    assert_not @gift.valid?
  end
  
  test "if check payment selected then check number and date should be present" do
    @gift.gift_type = "Check"
    assert_not @gift.valid?
    @gift.check_number = "1234"
    @gift.check_date = DateTime.parse("2015-12-31 00:00:00")
    assert @gift.valid?
  end
end
