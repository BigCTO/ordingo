# == Schema Information
#
# Table name: prices
#
#  id              :bigint           not null, primary key
#  discount_amount :decimal(8, 2)
#  shipping_fee    :decimal(8, 2)
#  subtotal        :decimal(8, 2)
#  tax_amount      :decimal(8, 2)
#  total           :decimal(8, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  order_id        :bigint           not null
#
# Indexes
#
#  index_prices_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
class Price < ApplicationRecord
  belongs_to :order
  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :prices, partial: "prices/index", locals: { price: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :prices, target: dom_id(self, :index) }


end
