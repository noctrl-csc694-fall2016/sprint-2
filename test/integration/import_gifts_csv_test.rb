require 'test_helper'

class ImportGiftsCsvTest < ActionDispatch::IntegrationTest
  test "should get import gifts begin" do
    get import_gifts_begin_path
    assert_response :success
    assert_select "title", "Import Gifts Begin | Gift Garden"
  end
  
  test "should get import gifts next" do
    get import_gifts_next_path
    assert_response :success
    assert_select "title", "Import Gifts | Gift Garden"
  end
end