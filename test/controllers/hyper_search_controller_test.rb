#----------------------------------#
# Hyper Search Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class HyperSearchControllerTest < ActionDispatch::IntegrationTest

  test 'should get_hypersearch_all_path' do
    get hyper_surf_all_path
    assert_response :success
    assert_select "title", "Hyper Surf Gift Garden | Gift Garden"
  end
  
  test "should get_hypersearch_donors_path" do
    get hyper_surf_donors_path
    assert_response :success
    assert_select "title", "Hyper Surf For A Donor | Gift Garden"
  end
  
  test "should get_hypersearch_activities_path" do
    get hyper_surf_activities_path
    assert_response :success
    assert_select "title", "Hyper Surf For A Activity | Gift Garden"
  end
end
