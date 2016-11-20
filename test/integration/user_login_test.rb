require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { username: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information" do
    get login_path
    post login_path, params: { session: { username:    @user.username,
                                          password: @user.password } }
    assert_template 'sessions/new'
  end
  
  
end