require 'test_helper'

class ImportGiftsCsvTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "should get import gifts instruction" do
    log_in_as(@user)
    get import_gifts_inst_path
    assert_response :success
    assert_select "title", "Import Gifts Instruction | Gift Garden"
  end
  
  test "import gifts instruction layout links" do
    log_in_as(@user)
    get import_gifts_inst_path
    assert_template 'import_export/import_gifts_inst'
    assert_select "a[href=?]", "/import-gifts-step-one", count: 2
    assert_select "a[href=?]", "/import-gifts-step-two"
    assert_select "a[href=?]", "/import-gifts-step-three"
    assert_select "a[href=?]", "/import-export"
  end
  
  test "should get warning if no file chosen" do
    log_in_as(@user)
    get import_gifts_step_two_path
    post "/import-gifts-validate"
    assert_equal 'Please choose a file.', flash[:error]
    get import_gifts_step_two_path
    post "/import-gifts-import"
    assert_equal 'Please choose a file.', flash[:error]
  end
end