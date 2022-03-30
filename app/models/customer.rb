# == Schema Information
#
# Table name: customers
#
#  id         :bigint           not null, primary key
#  email      :string
#  first_name :string
#  last_name  :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
class Customer < ApplicationRecord
  include Webhook::Observable
  acts_as_tenant :account
  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :customers, partial: "customers/index", locals: { customer: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :customers, target: dom_id(self, :index) }

  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def webhook_payload
    { customer: self }
  end
end
