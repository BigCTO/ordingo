# == Schema Information
#
# Table name: webhook_endpoints
#
#  id          :bigint           not null, primary key
#  enabled     :boolean          default(TRUE)
#  event_types :string           default([]), not null, is an Array
#  target_url  :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#
# Indexes
#
#  index_webhook_endpoints_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class WebhookEndpoint < ApplicationRecord
  has_many :webhook_events, inverse_of: :webhook_endpoint

  validates :target_url, presence: true, format: URI.regexp(%w(http https))
  validates :event_types, presence: true
end
