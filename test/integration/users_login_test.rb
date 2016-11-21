#----------------------------------#
# Sessions Controller Test
# original written by: Pat M, Nov 20 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'
require 'sessions_helper'

class UsersLoginLogoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  #makes sure a user can't login with invalid (empty) information
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { username: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  #tests user logout after login
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { username:    @user.username,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to home_path
    follow_redirect!
    assert_template "static_pages/home"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", '/home'
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to login_path
    follow_redirect!
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  #ensures that there's no 'remember me' token/cookie being stored
  test "login without remembering" do
    log_in_as(@user)
    assert_nil cookies['remember_token']
  end
end