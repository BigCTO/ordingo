json.extract! price, :id, :order_id, :total, :subtotal, :discount_amount, :tax_amount, :shipping_fee, :created_at, :updated_at
json.url price_url(price, format: :json)
