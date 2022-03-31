# frozen_string_literal: true

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
class Order < ApplicationRecord
  include Webhook::Observable
  acts_as_tenant :account
  extend FriendlyId
  friendly_id :slug_candidates, use: :scoped, scope: :account
  before_commit :set_uuid, on: :create

  after_update :transaction_status_event, if: :saved_change_to_transaction_status?

  belongs_to :customer
  belongs_to :address
  has_many :line_items, dependent: :destroy

  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :orders, partial: 'orders/index', locals: { order: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :orders, target: dom_id(self, :index) }

  accepts_nested_attributes_for :line_items, allow_destroy: true
  STATUS = %w[pending open ready out_for_delivery completed cancelled].freeze
  enum fulfillment_status: STATUS, _suffix: true
  enum transaction_status: STATUS, _suffix: true
  enum delivery_method: STATUS, _suffix: true

  def slug_candidates
    if id.present?
      i = id.to_s
      [
        [i.rjust(4, '0').to_s]
      ]
    else
      [
        [:id]
      ]
    end
  end

  def set_uuid
    i = id.to_s
    self.uuid = i.rjust(4, '0').to_s
  end

  def transaction_status_event
    if [4, 5].include?(transaction_status)
      deliver_webhook(
        "transaction_status.#{STATUS[transaction_status.to_s.to_sym]}",
        { order: { id: id} }
      )
    end
  end

  def webhook_payload
    { order: self }
  end
end
