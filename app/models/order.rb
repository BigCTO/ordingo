# == Schema Information
#
# Table name: orders
#
#  id                 :bigint           not null, primary key
#  delivery_method    :integer          default(0)
#  discount_price     :decimal(8, 2)
#  fulfillment_status :integer          default(0)
#  slug               :string
#  subtotal_price     :decimal(8, 2)
#  total_price        :decimal(8, 2)
#  transaction_status :integer          default(0)
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
  after_commit :set_uuid, on: :create

  belongs_to :customer
  belongs_to :address
  has_many :line_items, dependent: :destroy

  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :orders, partial: "orders/index", locals: { order: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :orders, target: dom_id(self, :index) }

  accepts_nested_attributes_for :line_items, allow_destroy: true


  def slug_candidates
    if self.id.present?
      i = self.id.to_s
      [
        ["#{i.rjust(4,'0')}"]
      ]
    else
      [
        [:id]
      ]
    end
  end

  def set_uuid
    i = self.id.to_s
    self.uuid = "#{i.rjust(4,'0')}"
    self.slug = nil
    self.save
  end

 
end
