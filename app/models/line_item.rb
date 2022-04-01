# == Schema Information
#
# Table name: line_items
#
#  id         :bigint           not null, primary key
#  quantity   :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  variant_id :bigint           not null
#
# Indexes
#
#  index_line_items_on_order_id    (order_id)
#  index_line_items_on_variant_id  (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (variant_id => variants.id)
#
class LineItem < ApplicationRecord
  belongs_to :order, touch: true
  belongs_to :variant



  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :line_items, partial: "line_items/index", locals: { line_item: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :line_items, target: dom_id(self, :index) }



end
