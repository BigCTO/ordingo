# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  slug        :string
#  status      :integer
#  uuid        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#
# Indexes
#
#  index_products_on_slug  (slug) UNIQUE
#
class Product < ApplicationRecord
  include Webhook::Observable
  acts_as_tenant :account
  extend FriendlyId
  friendly_id :get_uuid, use: :scoped, scope: :account

  before_create :set_uuid
  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :products, partial: 'products/index', locals: { product: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :products, target: dom_id(self, :index) }

  has_many :variants, inverse_of: :product, dependent: :destroy
  has_many :product_options, inverse_of: :product, dependent: :destroy
  has_one_attached :image
  has_rich_text :description

  enum status: %w[draft active archive]

  accepts_nested_attributes_for :variants, reject_if: proc { |attributes|
                                                        attributes['name'].blank?
                                                      }, allow_destroy: true
  accepts_nested_attributes_for :product_options, reject_if: proc { |attributes|
                                                               attributes['name'].blank?
                                                             }, allow_destroy: true

  OPTION_SEPARATOR = '-op-sep-'
  OPTION_KEY_VAL_SEPARATOR = '-okv-sep-'

  def get_uuid
    "P-#{SecureRandom.alphanumeric(10)}"
  end

  def set_uuid
    self.uuid = slug
  end

  def webhook_payload
    handle_variants
    { product: self }
  end

  def handle_variants
    variants = []
    product_options.order(:name).each do |option|
      value = option.value
      value = value.split(',').map(&:strip) unless value.is_a?(Array)
      variants << value.map { |each_val| "#{option.name}#{OPTION_KEY_VAL_SEPARATOR}#{each_val}" }
    end
    return unless variants.present?

    create_destroy_variants(self.class.possible_options(variants))
  end

  def create_destroy_variants(possible_options)
    created_variants = []
    possible_options.each do |option|
      created_variants << if option.is_a?(Array)
                            Variant.find_or_create_by!(option: option.join(OPTION_SEPARATOR), product_id: id).id
                          else
                            Variant.find_or_create_by!(option: option, product_id: id).id
                          end
    end
    Variant.where('id NOT IN (?) AND product_id = ?', created_variants, id).destroy_all
  end

  def self.generate_all_options(options)
    variants = []
    options.each do |option|
      value = option['value']
      value = value.split(',').map(&:strip) unless value.is_a?(Array)
      variants << value.map { |each_val| "#{option['name']}#{OPTION_KEY_VAL_SEPARATOR}#{each_val}" }
    end
    return [] unless variants.present?

    possible_options(variants).map { |option| option.is_a?(Array) ? option.join(OPTION_SEPARATOR) : option }
  end

  def self.possible_options(variants)
    variants[1..].inject(variants[0]) { |m, v| m.product(v).map(&:flatten) }
  end

end
