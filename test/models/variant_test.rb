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
require "test_helper"

class VariantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end