class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.integer :account_id
      t.belongs_to :order, null: false, foreign_key: true
      t.integer :product_id
      t.integer :variant_id
      t.string :product_name
      t.string :variant_name
      t.decimal :weight
      t.decimal :total_price, precision: 8, scale: 2
      t.decimal :subtotal_price, precision: 8, scale: 2
      t.decimal :discount_price, precision: 8, scale: 2
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
