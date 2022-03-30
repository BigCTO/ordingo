# == Schema Information
#
# Table name: webhook_events
#
#  id                  :bigint           not null, primary key
#  payload             :jsonb            not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  webhook_endpoint_id :integer          not null
#
# Indexes
#
#  index_webhook_events_on_webhook_endpoint_id  (webhook_endpoint_id)
#
class WebhookEvent < ApplicationRecord
  belongs_to :webhook_endpoint, inverse_of: :webhook_events

  attribute :payload, :string, array: true, default: []
  validates :webhook_endpoint_id, presence: true
  validates :payload, presence: true

  EVENT_TYPES = %w[customer.created customer.updated order.created order.updated product.created product.updated].freeze

end
