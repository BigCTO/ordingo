# == Schema Information
#
# Table name: product_options
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  value      :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_product_options_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class ProductOption < ApplicationRecord
  belongs_to :product
end
