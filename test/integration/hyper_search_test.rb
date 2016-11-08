#----------------------------------#
# Hyper Search Integration Test
# original written by: Jason K, Nov 7 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class HyperSearchTest < ActionDispatch::IntegrationTest
    
  def setup
    @donor = donors(:andy)
    @activity = activities(:golf)
  end

  test "successful hyper search donor with results" do
    get hyper_surf_donors_path
    assert_template 'hyper_surf/donors'
    get hyper_surf_donors_path(@donor), params: { search: "White" }
    #assert_redirected_to hyper_surf_donors_path
    assert_select "span.record-count", "1 result located for the surf term \"White\"."
  end
  
  test "successful hyper search donor with no results" do
    get hyper_surf_donors_path
    assert_template 'hyper_surf/donors'
    get hyper_surf_donors_path(@donor), params: { search: "ZZZZZZZZZ" }
    assert_select "span.record-count", "0 results located for the surf term \"ZZZZZZZZZ\"."
    assert_select "h3.no-records-found", "No donors located given your search criteria."
  end
  
  test "successful hyper search activity with results" do
    get hyper_surf_activities_path
    assert_template 'hyper_surf/activities'
    get hyper_surf_activities_path(@activity), params: { search: "Golf" }
    #assert_redirected_to hyper_surf_donors_path
    assert_select "span.record-count", "1 result located for the surf term \"Golf\"."
  end
  
  test "successful hyper search activity with no results" do
    get hyper_surf_activities_path
    assert_template 'hyper_surf/activities'
    get hyper_surf_activities_path(@activity), params: { search: "XXX" }
    #assert_redirected_to hyper_surf_donors_path
    assert_select "span.record-count", "0 results located for the surf term \"XXX\"."
    assert_select "h3.no-records-found", "No activities located given your search criteria."
  end
  
  test "successful hyper search all with results" do
    get hyper_surf_all_path
    assert_template 'hyper_surf/all'
    get hyper_surf_all_path(@donor), params: { term: "White" }
    assert_select "span.record-count", "1 result located for the surf term \"White\"."
  end
  
  test "successful hyper search all with no results" do
    get hyper_surf_all_path
    assert_template 'hyper_surf/all'
    get hyper_surf_all_path(@donor), params: { term: "XXX" }
    assert_select "span.record-count", "0 results located for the surf term \"XXX\"."
  end
end