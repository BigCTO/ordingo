# frozen_string_literal: true

module Webhook
  module Delivery
    extend ActiveSupport::Concern

    def webhook_payload
      {}
    end

    def deliver_webhook(action, payload = nil)
      event_name = "#{self.class.name.underscore}.#{action}"
      deliver_webhook_event(event_name, payload || webhook_payload)
    end

    def deliver_webhook_event(event_name, payload)
      event = Webhook::Event.new(event_name, payload || {})
      WebhookEndpoint.where("'#{event_name}' = ANY (event_types) AND enabled is True").each do |endpoint|
        endpoint.deliver(event)
      end
    end
  end
end
