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
require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
