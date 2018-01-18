require 'test_helper'

class ProductAssembliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_assembly = product_assemblies(:one)
  end

  test "should get index" do
    get product_assemblies_url
    assert_response :success
  end

  test "should get new" do
    get new_product_assembly_url
    assert_response :success
  end

  test "should create product_assembly" do
    assert_difference('ProductAssembly.count') do
      post product_assemblies_url, params: { product_assembly: { assembly_id: @product_assembly.assembly_id, product_id: @product_assembly.product_id, qty: @product_assembly.qty } }
    end

    assert_redirected_to product_assembly_url(ProductAssembly.last)
  end

  test "should show product_assembly" do
    get product_assembly_url(@product_assembly)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_assembly_url(@product_assembly)
    assert_response :success
  end

  test "should update product_assembly" do
    patch product_assembly_url(@product_assembly), params: { product_assembly: { assembly_id: @product_assembly.assembly_id, product_id: @product_assembly.product_id, qty: @product_assembly.qty } }
    assert_redirected_to product_assembly_url(@product_assembly)
  end

  test "should destroy product_assembly" do
    assert_difference('ProductAssembly.count', -1) do
      delete product_assembly_url(@product_assembly)
    end

    assert_redirected_to product_assemblies_url
  end
end
