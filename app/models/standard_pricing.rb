# == Schema Information
#
# Table name: standard_pricings
#
#  id         :bigint           not null, primary key
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  variant_id :bigint           not null
#
# Indexes
#
#  index_standard_pricings_on_variant_id  (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (variant_id => variants.id)
#
class StandardPricing < ApplicationRecord
  belongs_to :variant
end
