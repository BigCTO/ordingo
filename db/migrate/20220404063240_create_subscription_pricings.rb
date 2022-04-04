class CreateSubscriptionPricings < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_pricings do |t|
      t.integer :interval_count
      t.string :interval
      t.decimal :price, precision: 8, scale: 2
      t.string :description
      t.belongs_to :variant, null: false, foreign_key: true
      t.timestamps
    end
  end
end
