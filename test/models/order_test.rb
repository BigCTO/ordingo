# == Schema Information
#
# Table name: orders
#
#  id                 :bigint           not null, primary key
#  delivery_method    :string           default(NULL)
#  discount_price     :decimal(8, 2)
#  fulfillment_status :string           default(NULL)
#  slug               :string
#  subtotal_price     :decimal(8, 2)
#  total_price        :decimal(8, 2)
#  transaction_status :string           default(NULL)
#  uuid               :string
#  weight             :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :integer
#  address_id         :bigint           not null
#  customer_id        :bigint           not null
#
# Indexes
#
#  index_orders_on_address_id   (address_id)
#  index_orders_on_customer_id  (customer_id)
#  index_orders_on_slug         (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (customer_id => customers.id)
#
require "test_helper"

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
