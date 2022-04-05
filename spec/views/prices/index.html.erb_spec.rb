require 'rails_helper'

RSpec.describe "prices/index", type: :view do
  before(:each) do
    assign(:prices, [
      Price.create!(
        order: nil,
        total: "9.99",
        subtotal: "9.99",
        discount_amount: "9.99",
        tax_amount: "9.99",
        shipping_fee: "9.99"
      ),
      Price.create!(
        order: nil,
        total: "9.99",
        subtotal: "9.99",
        discount_amount: "9.99",
        tax_amount: "9.99",
        shipping_fee: "9.99"
      )
    ])
  end

  it "renders a list of prices" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
  end
end
