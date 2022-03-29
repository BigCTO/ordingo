class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.string :street
      t.string :number
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.boolean :primary, null: false, default: false

      t.timestamps
    end
  end
end
