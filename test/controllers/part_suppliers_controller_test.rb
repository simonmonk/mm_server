require 'test_helper'

class PartSuppliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @part_supplier = part_suppliers(:one)
  end

  test "should get index" do
    get part_suppliers_url
    assert_response :success
  end

  test "should get new" do
    get new_part_supplier_url
    assert_response :success
  end

  test "should create part_supplier" do
    assert_difference('PartSupplier.count') do
      post part_suppliers_url, params: { part_supplier: {  } }
    end

    assert_redirected_to part_supplier_url(PartSupplier.last)
  end

  test "should show part_supplier" do
    get part_supplier_url(@part_supplier)
    assert_response :success
  end

  test "should get edit" do
    get edit_part_supplier_url(@part_supplier)
    assert_response :success
  end

  test "should update part_supplier" do
    patch part_supplier_url(@part_supplier), params: { part_supplier: {  } }
    assert_redirected_to part_supplier_url(@part_supplier)
  end

  test "should destroy part_supplier" do
    assert_difference('PartSupplier.count', -1) do
      delete part_supplier_url(@part_supplier)
    end

    assert_redirected_to part_suppliers_url
  end
end
