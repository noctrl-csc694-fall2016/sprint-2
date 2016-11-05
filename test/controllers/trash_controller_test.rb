#----------------------------------#
# Trash Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class TrashControllerTest < ActionDispatch::IntegrationTest
  test 'should get_root_path' do
    get trashes_path
    assert_response :success
    assert_select "title", "Trash Report | Gift Garden"
  end

  #test "should get show" do
  #  get trash_show_url
  #  assert_response :success
  #end

end
