json.extract! order, :account_id, :uuid, :customer_id, :address_id, :transaction_status, :delivery_method, :fulfillment_status, :created_at, :updated_at
json.url order_url(order, format: :json)

if order.customer.present?
  json.customer order.customer, :id, :first_name, :last_name, :phone, :email
end

json.line_items order.line_items, :id, :order_id, :product_id, :variant_id, :product_name, :variant_name, :quantity, :weight, :total_price, :subtotal_price, :discount_price, :created_at, :updated_at