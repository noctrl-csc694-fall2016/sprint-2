require 'test_helper'

  #----------------------------------#
  # Activity Model Test
  # original written by: Andy W Nov 8 2016
  # major contributions by:
  #             
  #----------------------------------#


class ActivityTest < ActiveSupport::TestCase
  
  def setup
    @activity = activities(:golf)
  end

  
  test "valid activity" do 
    assert @activity.valid?
  end
  
  test "name should be present" do 
    @activity.name = nil
    assert_not @activity.valid?
  end
  
  test "goal should be present" do 
    @activity.goal = nil
    assert_not @activity.valid?
  end
  
  test "goal should not be negative" do 
    @activity.goal = -112.50
    assert_not @activity.valid?
  end
  
  test "end_date should not be before start_date" do
    @activity.start_date = DateTime.parse("2015-1-15 00:00:00")
    @activity.end_date = DateTime.parse("2014-1-15 00:00:00")
    assert_not @activity.valid?
  end
end
