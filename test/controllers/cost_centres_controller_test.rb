require 'test_helper'

class CostCentresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cost_centre = cost_centres(:one)
  end

  test "should get index" do
    get cost_centres_url
    assert_response :success
  end

  test "should get new" do
    get new_cost_centre_url
    assert_response :success
  end

  test "should create cost_centre" do
    assert_difference('CostCentre.count') do
      post cost_centres_url, params: { cost_centre: { code: @cost_centre.code, name: @cost_centre.name } }
    end

    assert_redirected_to cost_centre_url(CostCentre.last)
  end

  test "should show cost_centre" do
    get cost_centre_url(@cost_centre)
    assert_response :success
  end

  test "should get edit" do
    get edit_cost_centre_url(@cost_centre)
    assert_response :success
  end

  test "should update cost_centre" do
    patch cost_centre_url(@cost_centre), params: { cost_centre: { code: @cost_centre.code, name: @cost_centre.name } }
    assert_redirected_to cost_centre_url(@cost_centre)
  end

  test "should destroy cost_centre" do
    assert_difference('CostCentre.count', -1) do
      delete cost_centre_url(@cost_centre)
    end

    assert_redirected_to cost_centres_url
  end
end
