class CreateStandardPricings < ActiveRecord::Migration[7.0]
  def change
    create_table :standard_pricings do |t|
      t.decimal :price, precision: 8, scale: 2
      t.belongs_to :variant, null: false, foreign_key: true
      t.timestamps
    end
  end
end
