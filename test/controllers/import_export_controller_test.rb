#----------------------------------#
# Import/Export Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class ImportExportControllerTest < ActionDispatch::IntegrationTest
  test "should get_Import-Export path" do
    @user = users(:michael)
    log_in_as(@user)
    get import_export_path
    assert_response :success
    assert_select "title", "Import-Export Information | Gift Garden"
  end
end
