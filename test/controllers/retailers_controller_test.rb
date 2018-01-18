require 'test_helper'

class RetailersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @retailer = retailers(:one)
  end

  test "should get index" do
    get retailers_url
    assert_response :success
  end

  test "should get new" do
    get new_retailer_url
    assert_response :success
  end

  test "should create retailer" do
    assert_difference('Retailer.count') do
      post retailers_url, params: { retailer: { contact_email: @retailer.contact_email, contact_name: @retailer.contact_name, name: @retailer.name, notes: @retailer.notes } }
    end

    assert_redirected_to retailer_url(Retailer.last)
  end

  test "should show retailer" do
    get retailer_url(@retailer)
    assert_response :success
  end

  test "should get edit" do
    get edit_retailer_url(@retailer)
    assert_response :success
  end

  test "should update retailer" do
    patch retailer_url(@retailer), params: { retailer: { contact_email: @retailer.contact_email, contact_name: @retailer.contact_name, name: @retailer.name, notes: @retailer.notes } }
    assert_redirected_to retailer_url(@retailer)
  end

  test "should destroy retailer" do
    assert_difference('Retailer.count', -1) do
      delete retailer_url(@retailer)
    end

    assert_redirected_to retailers_url
  end
end
