class CreateWebhookEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_endpoints do |t|
      t.string :target_url, null: false
      t.string :event_types, null: false, array: true, default: []
      t.boolean :enabled, default: true
      t.references :account, foreign_key: true, null: false
      t.timestamps
    end
  end
end
