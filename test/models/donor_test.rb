require 'test_helper'

  #----------------------------------#
  # GiftGarden Donors Model Test
  # original written by: Andy W Nov 8 2016
  # major contributions by:
  #                     
  #----------------------------------#

class DonorTest < ActiveSupport::TestCase
  
  def setup
    @donor = donors(:andy)
    
  end

  
  test "valid donor" do 
    assert @donor.valid?
  end
  
  test "first name should be present" do
    @donor.first_name = nil
    assert_not @donor.valid?
  end
  
  test "last name should be present" do
    @donor.last_name = nil
    assert_not @donor.valid?
  end
  
  test "address should be present" do
    @donor.address = nil
    assert_not @donor.valid?
  end
  
  test "city should be present" do
    @donor.city = nil
    assert_not @donor.valid?
  end
  
  test "state should be present" do
    @donor.state = nil
    assert_not @donor.valid?
  end
  

end