require "application_system_test_case"

class WebhookEndpointsTest < ApplicationSystemTestCase
  setup do
    @webhook_endpoint = webhook_endpoints(:one)
  end

  test "visiting the index" do
    visit webhook_endpoints_url
    assert_selector "h1", text: "Webhook Endpoints"
  end

  test "creating a Webhook endpoint" do
    visit webhook_endpoints_url
    click_on "New Webhook Endpoint"

    click_on "Create Webhook endpoint"

    assert_text "Webhook endpoint was successfully created"
    assert_selector "h1", text: "Webhook Endpoints"
  end

  test "updating a Webhook endpoint" do
    visit webhook_endpoint_url(@webhook_endpoint)
    click_on "Edit", match: :first

    click_on "Update Webhook endpoint"

    assert_text "Webhook endpoint was successfully updated"
    assert_selector "h1", text: "Webhook Endpoints"
  end

  test "destroying a Webhook endpoint" do
    visit edit_webhook_endpoint_url(@webhook_endpoint)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Webhook endpoint was successfully destroyed"
  end
end
