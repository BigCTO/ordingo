class CreateWebhookEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_events do |t|
      t.integer :webhook_endpoint_id, null: false, index: true
      t.jsonb :payload, null: false
      t.timestamps
      t.boolean :delivered, default: false
      t.text :response, null: true
    end
    add_foreign_key :webhook_events, :webhook_endpoints, on_delete: :cascade, validate: false
  end
end
