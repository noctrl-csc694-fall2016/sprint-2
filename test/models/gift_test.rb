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
  
<<<<<<< HEAD
  test "if check payment selected then check number and date should be present" do
    @gift.gift_type = "Check"
    assert_not @gift.valid?
    @gift.check_number = "1234"
    @gift.check_date = DateTime.parse("2015-12-31 00:00:00")
    assert @gift.valid?
  end
=======
  test "check_number should be present only if gift_type is check" do
    #Gift already set to cash and Gift2 set to Check, but want to ensure they're not changed.
    @gift.gift_type = 'Cash'
    @gift.check_number = nil
    assert @gift.valid?
    @gift2.gift_type = 'Check'
    @gift2.check_number = nil
    assert_not @gift2.valid?
  end
  
  test "check_date should be present only if gift_type is check" do
    @gift.gift_type = 'Cash'
    @gift.check_date = nil
    assert @gift.valid?
    @gift2.gift_type = 'Check'
    @gift2.check_date = nil
    assert_not @gift2.valid?
  end
  
>>>>>>> 6e392e5ed593ab2ea5a1545c14e0f9ba7e691a95
end
