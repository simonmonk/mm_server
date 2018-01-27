require 'test_helper'

class PartCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @part_category = part_categories(:one)
  end

  test "should get index" do
    get part_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_part_category_url
    assert_response :success
  end

  test "should create part_category" do
    assert_difference('PartCategory.count') do
      post part_categories_url, params: { part_category: { name: @part_category.name } }
    end

    assert_redirected_to part_category_url(PartCategory.last)
  end

  test "should show part_category" do
    get part_category_url(@part_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_part_category_url(@part_category)
    assert_response :success
  end

  test "should update part_category" do
    patch part_category_url(@part_category), params: { part_category: { name: @part_category.name } }
    assert_redirected_to part_category_url(@part_category)
  end

  test "should destroy part_category" do
    assert_difference('PartCategory.count', -1) do
      delete part_category_url(@part_category)
    end

    assert_redirected_to part_categories_url
  end
end
