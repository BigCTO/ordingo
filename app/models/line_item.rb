# == Schema Information
#
# Table name: line_items
#
#  id             :bigint           not null, primary key
#  discount_price :decimal(8, 2)
#  product_name   :string
#  quantity       :integer          default(1)
#  subtotal_price :decimal(8, 2)
#  total_price    :decimal(8, 2)
#  variant_name   :string
#  weight         :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#  order_id       :bigint           not null
#  product_id     :integer
#  variant_id     :integer
#
# Indexes
#
#  index_line_items_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
class LineItem < ApplicationRecord
  acts_as_tenant :account
  belongs_to :order, touch: true

  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :line_items, partial: "line_items/index", locals: { line_item: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :line_items, target: dom_id(self, :index) }
end
