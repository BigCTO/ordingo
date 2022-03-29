require "application_system_test_case"

class VariantsTest < ApplicationSystemTestCase
  setup do
    @variant = variants(:one)
  end

  test "visiting the index" do
    visit variants_url
    assert_selector "h1", text: "Variants"
  end

  test "creating a Variant" do
    visit variants_url
    click_on "New Variant"

    fill_in "Account", with: @variant.account_id
    fill_in "Description", with: @variant.description
    fill_in "Inventory", with: @variant.inventory
    fill_in "Name", with: @variant.name
    fill_in "Price", with: @variant.price
    fill_in "Product", with: @variant.product_id
    fill_in "Weight", with: @variant.weight
    click_on "Create Variant"

    assert_text "Variant was successfully created"
    assert_selector "h1", text: "Variants"
  end

  test "updating a Variant" do
    visit variant_url(@variant)
    click_on "Edit", match: :first

    fill_in "Account", with: @variant.account_id
    fill_in "Description", with: @variant.description
    fill_in "Inventory", with: @variant.inventory
    fill_in "Name", with: @variant.name
    fill_in "Price", with: @variant.price
    fill_in "Product", with: @variant.product_id
    fill_in "Weight", with: @variant.weight
    click_on "Update Variant"

    assert_text "Variant was successfully updated"
    assert_selector "h1", text: "Variants"
  end

  test "destroying a Variant" do
    visit edit_variant_url(@variant)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Variant was successfully destroyed"
  end
end
