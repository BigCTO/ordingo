class CreateWebhookEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_events do |t|
      t.integer :webhook_endpoint_id, null: false, index: true
      t.jsonb :payload, null: false
      t.timestamps
    end
  end
end
