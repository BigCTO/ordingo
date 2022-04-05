require 'rails_helper'

RSpec.describe "prices/show", type: :view do
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

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
  end
end
