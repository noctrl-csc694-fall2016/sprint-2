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

end
