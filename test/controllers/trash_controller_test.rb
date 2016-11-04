require 'test_helper'

class TrashControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get trash_index_url
    assert_response :success
  end

  test "should get show" do
    get trash_show_url
    assert_response :success
  end

end
