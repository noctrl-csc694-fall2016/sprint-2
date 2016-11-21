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
    @user_regular = users(:bob)
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

  #makes sure that users not logged in can't access the edit user page
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  #makes sure that users not logged in can't access the user list page
  test "should redirect users list when not logged in" do
    get '/users'
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  #makes sure that users not logged in can't access the destroy user route
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
end
