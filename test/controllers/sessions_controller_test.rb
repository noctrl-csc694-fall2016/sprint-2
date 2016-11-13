#----------------------------------#
# Sessions Controller Test
# original written by: Pat M, Nov 7 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should get create" do
    get login_path
    assert_response :success
  end

  test "should get destroy" do
    get login_path
    assert_response :success
  end

end
