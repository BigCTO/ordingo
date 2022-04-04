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
require 'rails_helper'

RSpec.describe Price, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
