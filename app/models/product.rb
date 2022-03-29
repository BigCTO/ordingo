# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  status     :integer
#  type_of    :integer
#  uuid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_products_on_slug  (slug) UNIQUE
#
class Product < ApplicationRecord
  acts_as_tenant :account
  extend FriendlyId
  friendly_id :get_uuid, use: :scoped, scope: :account
  
  before_create :set_uuid
  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :products, partial: "products/index", locals: { product: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :products, target: dom_id(self, :index) }

  has_many :variants, inverse_of: :product, dependent: :destroy
  has_one_attached :image
  has_rich_text :description

  enum type_of: {single: 0, bundle: 1}
  enum status: {draft: 0, active: 1, archive: 2}

  accepts_nested_attributes_for :variants, reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true


  def get_uuid
   "P-#{SecureRandom.alphanumeric(10)}"
  end

  def set_uuid
    self.uuid = self.slug
  end

end
