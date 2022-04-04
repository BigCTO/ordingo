# == Schema Information
#
# Table name: orders
#
#  id                 :bigint           not null, primary key
#  delivery_method    :string           default("pending")
#  discount_price     :decimal(8, 2)
#  fulfillment_status :string           default("pending")
#  slug               :string
#  subtotal_price     :decimal(8, 2)
#  total_price        :decimal(8, 2)
#  transaction_status :string           default("pending")
#  uuid               :string
#  weight             :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :integer
#  address_id         :bigint
#  customer_id        :bigint
#
# Indexes
#
#  index_orders_on_address_id   (address_id)
#  index_orders_on_customer_id  (customer_id)
#  index_orders_on_slug         (slug) UNIQUE
#
require "test_helper"

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
