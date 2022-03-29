# == Schema Information
#
# Table name: bundles
#
#  id                 :bigint           not null, primary key
#  quantity           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :integer
#  bundled_product_id :bigint
#  variant_id         :bigint           not null
#
# Indexes
#
#  index_bundles_on_bundled_product_id  (bundled_product_id)
#  index_bundles_on_variant_id          (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (variant_id => variants.id)
#
class Bundle < ApplicationRecord
  acts_as_tenant :account
  
  belongs_to :variant
  belongs_to :bundled_product, class_name: 'Variant', optional: true

  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :bundles, partial: "bundles/index", locals: { bundle: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :bundles, target: dom_id(self, :index) }
end
