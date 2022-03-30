require 'net/http'

module Webhook
  class DeliveryWorker < ApplicationJob
    queue_as :default

    def perform(webhook_endpoint_id, payload)
      webhook_endpoint = WebhookEndpoint.find(webhook_endpoint_id)
      return unless webhook_endpoint.present?
      webhook_event = WebhookEvent.create!(webhook_endpoint: webhook_endpoint, payload:JSON.parse(payload))
      response = request(webhook_endpoint.target_url, payload)
      case response.code
      when 400..599
        webhook_event.update(response: response.to_s)
        raise response.to_s
      else
        true
      end
      webhook_event.update(delivered: true)
    rescue => error
      webhook_event.update(response: error.message)
    end

    private

    def request(endpoint, payload)
      uri = URI.parse(endpoint)

      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      request.body = payload

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')

      http.request(request)
    end
  end
end
