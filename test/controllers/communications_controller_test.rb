require 'test_helper'

class CommunicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @communication = communications(:one)
  end

  test "should get index" do
    get communications_url
    assert_response :success
  end

  test "should get new" do
    get new_communication_url
    assert_response :success
  end

  test "should create communication" do
    assert_difference('Communication.count') do
      post communications_url, params: { communication: { communication_date: @communication.communication_date, email_url: @communication.email_url, notes: @communication.notes, prospect_id: @communication.prospect_id, user_id: @communication.user_id } }
    end

    assert_redirected_to communication_url(Communication.last)
  end

  test "should show communication" do
    get communication_url(@communication)
    assert_response :success
  end

  test "should get edit" do
    get edit_communication_url(@communication)
    assert_response :success
  end

  test "should update communication" do
    patch communication_url(@communication), params: { communication: { communication_date: @communication.communication_date, email_url: @communication.email_url, notes: @communication.notes, prospect_id: @communication.prospect_id, user_id: @communication.user_id } }
    assert_redirected_to communication_url(@communication)
  end

  test "should destroy communication" do
    assert_difference('Communication.count', -1) do
      delete communication_url(@communication)
    end

    assert_redirected_to communications_url
  end
end
