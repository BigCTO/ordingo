class CreateVariantOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :variant_options do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.belongs_to :variant, null: false, foreign_key: true
      t.timestamps
    end
  end
end
