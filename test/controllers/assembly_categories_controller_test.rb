require 'test_helper'

class AssemblyCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assembly_category = assembly_categories(:one)
  end

  test "should get index" do
    get assembly_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_assembly_category_url
    assert_response :success
  end

  test "should create assembly_category" do
    assert_difference('AssemblyCategory.count') do
      post assembly_categories_url, params: { assembly_category: { name: @assembly_category.name, priority: @assembly_category.priority } }
    end

    assert_redirected_to assembly_category_url(AssemblyCategory.last)
  end

  test "should show assembly_category" do
    get assembly_category_url(@assembly_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_assembly_category_url(@assembly_category)
    assert_response :success
  end

  test "should update assembly_category" do
    patch assembly_category_url(@assembly_category), params: { assembly_category: { name: @assembly_category.name, priority: @assembly_category.priority } }
    assert_redirected_to assembly_category_url(@assembly_category)
  end

  test "should destroy assembly_category" do
    assert_difference('AssemblyCategory.count', -1) do
      delete assembly_category_url(@assembly_category)
    end

    assert_redirected_to assembly_categories_url
  end
end
