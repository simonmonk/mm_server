require 'test_helper'

class ProductPartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_part = product_parts(:one)
  end

  test "should get index" do
    get product_parts_url
    assert_response :success
  end

  test "should get new" do
    get new_product_part_url
    assert_response :success
  end

  test "should create product_part" do
    assert_difference('ProductPart.count') do
      post product_parts_url, params: { product_part: { part_id: @product_part.part_id, product_id: @product_part.product_id } }
    end

    assert_redirected_to product_part_url(ProductPart.last)
  end

  test "should show product_part" do
    get product_part_url(@product_part)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_part_url(@product_part)
    assert_response :success
  end

  test "should update product_part" do
    patch product_part_url(@product_part), params: { product_part: { part_id: @product_part.part_id, product_id: @product_part.product_id } }
    assert_redirected_to product_part_url(@product_part)
  end

  test "should destroy product_part" do
    assert_difference('ProductPart.count', -1) do
      delete product_part_url(@product_part)
    end

    assert_redirected_to product_parts_url
  end
end
