# == Schema Information
#
# Table name: webhook_events
#
#  id                  :bigint           not null, primary key
#  delivered           :boolean          default(FALSE)
#  payload             :jsonb            not null
#  response            :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  webhook_endpoint_id :integer          not null
#
# Indexes
#
#  index_webhook_events_on_webhook_endpoint_id  (webhook_endpoint_id)
#
# Foreign Keys
#
#  fk_rails_...  (webhook_endpoint_id => webhook_endpoints.id) ON DELETE => cascade
#
class WebhookEvent < ApplicationRecord
  belongs_to :webhook_endpoint, inverse_of: :webhook_events

  validates :webhook_endpoint_id, presence: true
  validates :payload, presence: true

  EVENT_TYPES = %w[
    customer.created
    customer.updated
    customer.deleted
    order.created
    order.updated
    order.deleted
    order.transaction_status.completed
    order.transaction_status.cancelled
    product.created
    product.updated
    product.deleted
  ].freeze

end
