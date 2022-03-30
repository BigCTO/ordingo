json.extract! webhook_endpoint, :id, :created_at, :updated_at
json.url webhook_endpoint_url(webhook_endpoint, format: :json)
