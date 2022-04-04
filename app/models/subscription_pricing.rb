# frozen_string_literal: true

# == Schema Information
#
# Table name: subscription_pricings
#
#  id             :bigint           not null, primary key
#  description    :string
#  interval       :string
#  interval_count :integer
#  price          :decimal(8, 2)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  variant_id     :bigint           not null
#
# Indexes
#
#  index_subscription_pricings_on_variant_id  (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (variant_id => variants.id)
#
class SubscriptionPricing < ApplicationRecord
  belongs_to :variant

  INTERVAL = {
    "Month": 'month',
    "Year": 'year',
    "Week": 'week',
    "Day": 'day'
  }.freeze
end
