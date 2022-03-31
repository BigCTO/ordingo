# frozen_string_literal: true

class ChageOrderStatusToString < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :transaction_status, :string, default: "pending"
    change_column :orders, :fulfillment_status, :string, default: "pending"
    change_column :orders, :delivery_method, :string, default: "pending"
  end
end
