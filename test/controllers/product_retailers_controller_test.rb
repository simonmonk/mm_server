require 'test_helper'

class ProductRetailersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_retailer = product_retailers(:one)
  end

  test "should get index" do
    get product_retailers_url
    assert_response :success
  end

  test "should get new" do
    get new_product_retailer_url
    assert_response :success
  end

  test "should create product_retailer" do
    assert_difference('ProductRetailer.count') do
      post product_retailers_url, params: { product_retailer: {  } }
    end

    assert_redirected_to product_retailer_url(ProductRetailer.last)
  end

  test "should show product_retailer" do
    get product_retailer_url(@product_retailer)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_retailer_url(@product_retailer)
    assert_response :success
  end

  test "should update product_retailer" do
    patch product_retailer_url(@product_retailer), params: { product_retailer: {  } }
    assert_redirected_to product_retailer_url(@product_retailer)
  end

  test "should destroy product_retailer" do
    assert_difference('ProductRetailer.count', -1) do
      delete product_retailer_url(@product_retailer)
    end

    assert_redirected_to product_retailers_url
  end
end
