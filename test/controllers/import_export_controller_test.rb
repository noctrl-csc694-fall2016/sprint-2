#----------------------------------#
# Import/Export Controller Test
# original written by: Jason K, Nov 5 2016
# major contributions by:
#
#----------------------------------#
require 'test_helper'

class ImportExportControllerTest < ActionDispatch::IntegrationTest
  test "should get_Import-Export_path" do
    get import_export_path
    assert_response :success
    assert_select "title", "Import-Export Information | Gift Garden"
  end
  
  test "should get Inkind Import" do
    get inkind_path
    assert_response :success
    assert_select "title", "Import in Kind Gifts | Gift Garden"
  end
  
  test "should get General Import" do
    get inkind_path
    assert_response :success
    assert_select "title", "Import in Kind Gifts | Gift Garden"
  end
  
  test "should get Import Gifts Begin" do
    get import_gifts_begin_path
    assert_response :success
    assert_select "title", "Import Gifts Begin | Gift Garden"
  end
  
  test "should get Import Gifts Success" do
    get import_gifts_success_path
    assert_response :success
    assert_select "title", "Import Successful | Gift Garden"
  end
  
  

end
