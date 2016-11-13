#----------------------------------#
# Users Controller Test
# original written by: Pat M, Nov 7 2016
# major contributions by: Jason K
#
#----------------------------------#

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "should get users index when logged in" do
    log_in_as(@user)
    get users_index_url
    assert_response :success
  end

  #test "should get users show when logged in" do
  #  log_in_as(@user)
  #  get users_show_url
  #  assert_response :success
  #end

  #test "should get users edit when logged in" do
  #  log_in_as(@user)
  #  get users_edit_url
  #  assert_response :success
  #end

  #test "should get users create when logged in" do
  #  log_in_as(@user)
  #  get users_create_url
  #  assert_response :success
  #end

  #test "should get users update when logged in" do
  #  log_in_as(@user)
  #  get users_update_url
  #  assert_response :success
  #end

end
