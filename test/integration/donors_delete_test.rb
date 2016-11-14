#----------------------------------#
# Donors Delete Integration Test
# original written by: Wei H, Nov 7 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class DonorsDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @donor_y = donors(:andy) # donor with gift
    @donor_n = donors(:bob) # donor with no gift
  end
  
  test "delete donor with and without gift" do
    get edit_donor_path(@donor_y)
    assert_select "a", {count: 0, text: "Delete Donor"}
    get edit_donor_path(@donor_n)
    assert_select "a", text: "Delete Donor"
    assert_difference 'Donor.count', -1 do
      delete donor_path(@donor_n)
    end
    assert_response :redirect
    assert_redirected_to donors_path
  end
  
  test "Trash generated when a donor with no gift is deleted" do
    get edit_donor_path(@donor_n)
    assert_difference 'Trash.count', 1 do
      delete donor_path(@donor_n)
    end
    assert_response :redirect
    assert_redirected_to donors_path
  end

end