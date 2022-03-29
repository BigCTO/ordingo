require "application_system_test_case"

class AddressesTest < ApplicationSystemTestCase
  setup do
    @address = addresses(:one)
  end

  test "visiting the index" do
    visit addresses_url
    assert_selector "h1", text: "Addresses"
  end

  test "creating a Address" do
    visit addresses_url
    click_on "New Address"

    fill_in "City", with: @address.city
    fill_in "Country", with: @address.country
    fill_in "Customer", with: @address.customer_id
    fill_in "Number", with: @address.number
    check "Primary" if @address.primary
    fill_in "State", with: @address.state
    fill_in "Street", with: @address.street
    fill_in "Zipcode", with: @address.zipcode
    click_on "Create Address"

    assert_text "Address was successfully created"
    assert_selector "h1", text: "Addresses"
  end

  test "updating a Address" do
    visit address_url(@address)
    click_on "Edit", match: :first

    fill_in "City", with: @address.city
    fill_in "Country", with: @address.country
    fill_in "Customer", with: @address.customer_id
    fill_in "Number", with: @address.number
    check "Primary" if @address.primary
    fill_in "State", with: @address.state
    fill_in "Street", with: @address.street
    fill_in "Zipcode", with: @address.zipcode
    click_on "Update Address"

    assert_text "Address was successfully updated"
    assert_selector "h1", text: "Addresses"
  end

  test "destroying a Address" do
    visit edit_address_url(@address)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Address was successfully destroyed"
  end
end
