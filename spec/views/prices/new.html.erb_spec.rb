require 'rails_helper'

RSpec.describe "prices/new", type: :view do
  before(:each) do
    assign(:price, Price.new(
      order: nil,
      total: "9.99",
      subtotal: "9.99",
      discount_amount: "9.99",
      tax_amount: "9.99",
      shipping_fee: "9.99"
    ))
  end

  it "renders new price form" do
    render

    assert_select "form[action=?][method=?]", prices_path, "post" do

      assert_select "input[name=?]", "price[order_id]"

      assert_select "input[name=?]", "price[total]"

      assert_select "input[name=?]", "price[subtotal]"

      assert_select "input[name=?]", "price[discount_amount]"

      assert_select "input[name=?]", "price[tax_amount]"

      assert_select "input[name=?]", "price[shipping_fee]"
    end
  end
end
