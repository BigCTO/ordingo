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
require "test_helper"

class BundleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
