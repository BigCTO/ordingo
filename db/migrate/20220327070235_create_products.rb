class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.integer :account_id
      t.string :uuid
      t.string :name
      t.string :description
      t.integer :status
      t.string :slug

      t.index :slug, unique: true
      t.timestamps
    end
  end
end
