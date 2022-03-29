class CreateBundles < ActiveRecord::Migration[7.0]
  def change
    create_table :bundles do |t|
      t.integer :account_id
      t.belongs_to :variant, null: false, foreign_key: true
      t.belongs_to :bundled_product
      t.integer :quantity

      t.timestamps
    end
  end
end
