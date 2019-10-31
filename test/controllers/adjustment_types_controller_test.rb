require 'test_helper'

class AdjustmentTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @adjustment_type = adjustment_types(:one)
  end

  test "should get index" do
    get adjustment_types_url
    assert_response :success
  end

  test "should get new" do
    get new_adjustment_type_url
    assert_response :success
  end

  test "should create adjustment_type" do
    assert_difference('AdjustmentType.count') do
      post adjustment_types_url, params: { adjustment_type: { code: @adjustment_type.code, description: @adjustment_type.description, name: @adjustment_type.name } }
    end

    assert_redirected_to adjustment_type_url(AdjustmentType.last)
  end

  test "should show adjustment_type" do
    get adjustment_type_url(@adjustment_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_adjustment_type_url(@adjustment_type)
    assert_response :success
  end

  test "should update adjustment_type" do
    patch adjustment_type_url(@adjustment_type), params: { adjustment_type: { code: @adjustment_type.code, description: @adjustment_type.description, name: @adjustment_type.name } }
    assert_redirected_to adjustment_type_url(@adjustment_type)
  end

  test "should destroy adjustment_type" do
    assert_difference('AdjustmentType.count', -1) do
      delete adjustment_type_url(@adjustment_type)
    end

    assert_redirected_to adjustment_types_url
  end
end
