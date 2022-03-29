class CreateVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :variants do |t|
      t.integer :account_id
      t.string :uuid
      t.belongs_to :product, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.decimal :price, precision: 8, scale: 2
      t.decimal :weight
      t.integer :inventory
      t.string :slug

      t.index :slug, unique: true

      t.timestamps
    end
  end
end
