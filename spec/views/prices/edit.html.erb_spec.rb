require 'rails_helper'

RSpec.describe "prices/edit", type: :view do
  before(:each) do
    @price = assign(:price, Price.create!(
      order: nil,
      total: "9.99",
      subtotal: "9.99",
      discount_amount: "9.99",
      tax_amount: "9.99",
      shipping_fee: "9.99"
    ))
  end

  it "renders the edit price form" do
    render

    assert_select "form[action=?][method=?]", price_path(@price), "post" do

      assert_select "input[name=?]", "price[order_id]"

      assert_select "input[name=?]", "price[total]"

      assert_select "input[name=?]", "price[subtotal]"

      assert_select "input[name=?]", "price[discount_amount]"

      assert_select "input[name=?]", "price[tax_amount]"

      assert_select "input[name=?]", "price[shipping_fee]"
    end
  end
end
