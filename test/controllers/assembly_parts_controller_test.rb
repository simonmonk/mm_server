require 'test_helper'

class AssemblyPartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assembly_part = assembly_parts(:one)
  end

  test "should get index" do
    get assembly_parts_url
    assert_response :success
  end

  test "should get new" do
    get new_assembly_part_url
    assert_response :success
  end

  test "should create assembly_part" do
    assert_difference('AssemblyPart.count') do
      post assembly_parts_url, params: { assembly_part: { assembly_id: @assembly_part.assembly_id, part_id: @assembly_part.part_id, qty: @assembly_part.qty } }
    end

    assert_redirected_to assembly_part_url(AssemblyPart.last)
  end

  test "should show assembly_part" do
    get assembly_part_url(@assembly_part)
    assert_response :success
  end

  test "should get edit" do
    get edit_assembly_part_url(@assembly_part)
    assert_response :success
  end

  test "should update assembly_part" do
    patch assembly_part_url(@assembly_part), params: { assembly_part: { assembly_id: @assembly_part.assembly_id, part_id: @assembly_part.part_id, qty: @assembly_part.qty } }
    assert_redirected_to assembly_part_url(@assembly_part)
  end

  test "should destroy assembly_part" do
    assert_difference('AssemblyPart.count', -1) do
      delete assembly_part_url(@assembly_part)
    end

    assert_redirected_to assembly_parts_url
  end
end
