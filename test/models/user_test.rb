#----------------------------------#
# Sessions Controller Test
# original written by: Pat M, Nov 8 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  #creates an artifical user to test against
  def setup
    @user = User.new(username: "Example User", email: "user@example.com",
                      password_digest: "password", permission_level: 1)
  end

  #checks validity of user's model state
  test "should be valid" do
    assert @user.valid?
  end
  
  #checks to make sure a username is present
  test "name should be present" do
    @user.username = "     "
    assert_not @user.valid?
  end
  
  #checks to make sure an email is present
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  #checks to make sure a username isn't over 50 characters
  test "name should not be too long" do
    @user.username = "a" * 51
    assert_not @user.valid?
  end

  #checks to make sure a username isn't over 255 characters
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  #checks to make sure a valid email address is being used
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  #checks to make sure a user's email is unique in the db
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
end
