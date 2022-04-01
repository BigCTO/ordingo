class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :account_id
      t.string :uuid
      t.belongs_to :customer
      t.belongs_to :address
      t.decimal :total_price, precision: 8, scale: 2
      t.decimal :subtotal_price, precision: 8, scale: 2
      t.decimal :discount_price, precision: 8, scale: 2
      t.decimal :weight
      t.integer :transaction_status, default: 0
      t.integer :delivery_method, default: 0
      t.integer :fulfillment_status, default: 0
      t.string :slug

      t.index :slug, unique: true
      t.timestamps
    end
  end
end
