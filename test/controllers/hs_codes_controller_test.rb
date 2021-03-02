require 'test_helper'

class HsCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hs_code = hs_codes(:one)
  end

  test "should get index" do
    get hs_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_hs_code_url
    assert_response :success
  end

  test "should create hs_code" do
    assert_difference('HsCode.count') do
      post hs_codes_url, params: { hs_code: { code: @hs_code.code, description: @hs_code.description, nickname: @hs_code.nickname, notes: @hs_code.notes, url: @hs_code.url } }
    end

    assert_redirected_to hs_code_url(HsCode.last)
  end

  test "should show hs_code" do
    get hs_code_url(@hs_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_hs_code_url(@hs_code)
    assert_response :success
  end

  test "should update hs_code" do
    patch hs_code_url(@hs_code), params: { hs_code: { code: @hs_code.code, description: @hs_code.description, nickname: @hs_code.nickname, notes: @hs_code.notes, url: @hs_code.url } }
    assert_redirected_to hs_code_url(@hs_code)
  end

  test "should destroy hs_code" do
    assert_difference('HsCode.count', -1) do
      delete hs_code_url(@hs_code)
    end

    assert_redirected_to hs_codes_url
  end
end
