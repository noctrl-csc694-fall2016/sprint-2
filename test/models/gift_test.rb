require 'test_helper'

class GiftTest < ActiveSupport::TestCase

  def setup
    @gift = Gift.new(donation_date: "2016-02-10".to_date, amount: 720.0,
                      gift_type: "Check")
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
