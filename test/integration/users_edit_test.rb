#----------------------------------#
# Sessions Controller Test
# original written by: Pat M, Nov 20 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  #makes sure user is kept on edit page when an edit fails
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    #assert_template 'users/edit'
    patch user_path(@user), 
      params: { user: { username:  "",
                        email: "foo@invalid",
                        password:              "foo",
                        password_confirmation: "bar" } }

    assert_redirected_to '/users/' + @user.id.to_s
  end
end