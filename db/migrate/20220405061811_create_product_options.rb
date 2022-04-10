class CreateProductOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :product_options do |t|
      t.string :name, null: false
      t.jsonb :value, null: false
      t.belongs_to :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
