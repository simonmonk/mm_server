require 'test_helper'

class AdjustmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @adjustment = adjustments(:one)
  end

  test "should get index" do
    get adjustments_url
    assert_response :success
  end

  test "should get new" do
    get new_adjustment_url
    assert_response :success
  end

  test "should create adjustment" do
    assert_difference('Adjustment.count') do
      post adjustments_url, params: { adjustment: { adjustment_date: @adjustment.adjustment_date, adjustment_type: @adjustment.adjustment_type, notes: @adjustment.notes, value: @adjustment.value } }
    end

    assert_redirected_to adjustment_url(Adjustment.last)
  end

  test "should show adjustment" do
    get adjustment_url(@adjustment)
    assert_response :success
  end

  test "should get edit" do
    get edit_adjustment_url(@adjustment)
    assert_response :success
  end

  test "should update adjustment" do
    patch adjustment_url(@adjustment), params: { adjustment: { adjustment_date: @adjustment.adjustment_date, adjustment_type: @adjustment.adjustment_type, notes: @adjustment.notes, value: @adjustment.value } }
    assert_redirected_to adjustment_url(@adjustment)
  end

  test "should destroy adjustment" do
    assert_difference('Adjustment.count', -1) do
      delete adjustment_url(@adjustment)
    end

    assert_redirected_to adjustments_url
  end
end
