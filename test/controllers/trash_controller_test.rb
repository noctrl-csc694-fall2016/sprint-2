#----------------------------------#
# Trash Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class TrashControllerTest < ActionDispatch::IntegrationTest
  test 'should get trash report path' do
    @user = users(:michael)
    log_in_as(@user)
    get trashes_path
    assert_response :success
    assert_select "title", "Trash Report | Gift Garden"
  end
end
