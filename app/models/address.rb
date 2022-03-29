# == Schema Information
#
# Table name: addresses
#
#  id          :bigint           not null, primary key
#  city        :string
#  country     :string
#  number      :string
#  primary     :boolean          default(FALSE), not null
#  state       :string
#  street      :string
#  zipcode     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#
# Indexes
#
#  index_addresses_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
class Address < ApplicationRecord
  belongs_to :customer

  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :addresses, partial: "addresses/index", locals: { address: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :addresses, target: dom_id(self, :index) }
end
