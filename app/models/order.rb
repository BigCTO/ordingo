# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id                 :bigint           not null, primary key
#  delivery_method    :string           default("pending")
#  discount_price     :decimal(8, 2)
#  fulfillment_status :string           default("pending")
#  slug               :string
#  subtotal_price     :decimal(8, 2)
#  total_price        :decimal(8, 2)
#  transaction_status :string           default("pending")
#  uuid               :string
#  weight             :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :integer
#  address_id         :bigint
#  customer_id        :bigint
#
# Indexes
#
#  index_orders_on_address_id   (address_id)
#  index_orders_on_customer_id  (customer_id)
#  index_orders_on_slug         (slug) UNIQUE
#
class Order < ApplicationRecord
  include Webhook::Observable
  require 'taxjar'
  extend FriendlyId
  acts_as_tenant :account
  friendly_id :slug_candidates, use: :scoped, scope: :account
  before_commit :set_uuid, on: :create
  after_update :transaction_status_event, if: :saved_change_to_transaction_status?

  belongs_to :customer, optional: true
  belongs_to :address, optional: true
  
  has_one :price, dependent: :destroy

  has_many :line_items
  has_many :variants, through: :line_items


  after_save :set_price

  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :orders, partial: 'orders/index', locals: { order: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :orders, target: dom_id(self, :index) }

  accepts_nested_attributes_for :line_items, allow_destroy: true
  STATUS = {
    "pending"=>"pending",
    "open"=>"open",
    "ready"=>"ready",
    "out_for_delivery"=>"out_for_delivery",
    "completed"=>"completed",
    "cancelled"=>"cancelled"
  }.freeze
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
    return unless %w[completed cancelled].include?(transaction_status)

    deliver_webhook(
      "transaction_status.#{transaction_status}",
      { order: { id: } }
    )
  end

  def webhook_payload
    { order: self }
  end

  
  def sum_line_items_price
    price = 0.00
    self.line_items.each do |item|
      price += (item.variant.price * item.quantity)
    end
    return price
  end

  def set_price

    subtotal = self.sum_line_items_price
    tax_amount = 0
    discount_amount = 0
    shipping_fee = 0

      
    client = Taxjar::Client.new(api_key: '6021fe03661e5b800bee275c08878e07')

    tax = client.tax_for_order({
      :from_country => 'US',
      :from_zip => '84604',
      :from_state => 'UT',
      :from_city => 'Provo',
      :from_street => '986 N 1750 W',
      :to_country => 'US',
      :to_zip => '90002',
      :to_state => 'CA',
      :to_city => 'Los Angeles',
      :to_street => '1335 E 103rd St',
      :amount => subtotal,
      :shipping => shipping_fee,
      :nexus_addresses => [
        {
          :country => 'US',
          :zip => '84604',
          :state => 'UT',
          :city => 'Provo',
          :street => '986 N 1750 W',
        }
      ],
    })

    puts "//////////////////////// TAX ////////////////////////"
    puts tax

    puts tax_amount = tax.amount_to_collect
  
    total = (subtotal - discount_amount) + tax_amount + shipping_fee

    if self.price.nil? 
      self.create_price(
        total: total,
        subtotal: subtotal,
        discount_amount: discount_amount,
        tax_amount: tax_amount,
        shipping_fee: shipping_fee,
      )
    else
      self.price.update(
        total: total,
        subtotal: subtotal,
        discount_amount: discount_amount,
        tax_amount: tax_amount,
        shipping_fee: shipping_fee,
      )
    end

  end

  

end
