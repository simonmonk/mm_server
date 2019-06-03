require 'test_helper'

class BookKeepingCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_keeping_category = book_keeping_categories(:one)
  end

  test "should get index" do
    get book_keeping_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_book_keeping_category_url
    assert_response :success
  end

  test "should create book_keeping_category" do
    assert_difference('BookKeepingCategory.count') do
      post book_keeping_categories_url, params: { book_keeping_category: { code: @book_keeping_category.code, name: @book_keeping_category.name } }
    end

    assert_redirected_to book_keeping_category_url(BookKeepingCategory.last)
  end

  test "should show book_keeping_category" do
    get book_keeping_category_url(@book_keeping_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_keeping_category_url(@book_keeping_category)
    assert_response :success
  end

  test "should update book_keeping_category" do
    patch book_keeping_category_url(@book_keeping_category), params: { book_keeping_category: { code: @book_keeping_category.code, name: @book_keeping_category.name } }
    assert_redirected_to book_keeping_category_url(@book_keeping_category)
  end

  test "should destroy book_keeping_category" do
    assert_difference('BookKeepingCategory.count', -1) do
      delete book_keeping_category_url(@book_keeping_category)
    end

    assert_redirected_to book_keeping_categories_url
  end
end
