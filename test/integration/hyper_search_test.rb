#----------------------------------#
# Hyper Search Integration Test
# original written by: Jason K, Nov 7 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class HyperSearchTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "should_get_search_page_with_results" do
    log_in_as(@user)
    get hyper_surf_all_path, params: {term: "1"}
    assert_template 'hyper_surf/all'
    assert_select "title", "Hyper Surf | Gift Garden"
    assert_select "span.record-count", "3 results located for the surf term \"1\"."
    assert_response :success
  end
  
  test "should_get_search_page_with_no_results" do
    log_in_as(@user)
    get hyper_surf_all_path, params: {term: "|||||||"}
    assert_template 'hyper_surf/all'
    assert_select "title", "Hyper Surf | Gift Garden"
    assert_select "span.record-count", "0 results located for the surf term \"|||||||\"."
    assert_response :success
  end  
    
end