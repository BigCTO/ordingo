# == Schema Information
#
# Table name: variant_options
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  value      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  variant_id :bigint           not null
#
# Indexes
#
#  index_variant_options_on_variant_id  (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (variant_id => variants.id)
#
class VariantOption < ApplicationRecord
  belongs_to :variant
end
