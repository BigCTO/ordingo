class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.belongs_to :order, null: false, foreign_key: true
      t.decimal :total, precision: 8, scale: 2
      t.decimal :subtotal, precision: 8, scale: 2
      t.decimal :discount_amount, precision: 8, scale: 2
      t.decimal :tax_amount, precision: 8, scale: 2
      t.decimal :shipping_fee, precision: 8, scale: 2

      t.timestamps
    end
  end
end
