# == Schema Information
#
# Table name: variants
#
#  id          :bigint           not null, primary key
#  description :string
#  inventory   :integer
#  name        :string
#  price       :decimal(8, 2)
#  slug        :string
#  uuid        :string
#  weight      :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#  product_id  :bigint           not null
#
# Indexes
#
#  index_variants_on_product_id  (product_id)
#  index_variants_on_slug        (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class Variant < ApplicationRecord
  acts_as_tenant :account
  belongs_to :product
  extend FriendlyId
  friendly_id :get_uuid, use: :scoped, scope: :account

  before_create :set_uuid
  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :variants, partial: "variants/index", locals: { variant: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :variants, target: dom_id(self, :index) }
  
  has_many_attached :images
  has_many :bundles, dependent: :destroy
  has_many :bundled_products, through: :bundles

  has_many :line_items
  has_many :orders, through: :line_items

  accepts_nested_attributes_for :bundles, reject_if: :all_blank, allow_destroy: true

  def get_uuid
    "V-#{SecureRandom.alphanumeric(10)}"
   end
 
   def set_uuid
     self.uuid = self.slug
   end
end
