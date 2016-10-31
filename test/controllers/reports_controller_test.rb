require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get activities" do
    get reports_activities_url
    assert_response :success
  end

  test "should get donors" do
    get reports_donors_url
    assert_response :success
  end

  test "should get gifts" do
    get reports_gifts_url
    assert_response :success
  end

end
