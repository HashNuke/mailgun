module Mailgun
  # Interface to manage webhooks
  # https://documentation.mailgun.com/api-webhooks.html#webhooks
  class Webhook
    attr_accessor :default_webhook_url, :domain

    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain, url)
      @mailgun = mailgun
      @domain = domain
      @default_webhook_url = url
    end

    # List of currently available webhooks
    def available_ids
      %w(bounce deliver drop spam unsubscribe click open).map(&:to_sym)
    end

    # Returns a list of webhooks set for the specified domain
    def list
      Mailgun.submit :get, webhook_url
    end

    # Returns details about a the webhook specified in the URL
    def find(id)
      Mailgun.submit :get, webhook_url(id)
    end

    # Creates a new webhook
    # Note: Creating an Open or Click webhook will enable Open or Click tracking
    def create(id, url=default_webhook_url)
      params = {:id => id, :url => url}
      Mailgun.submit :post, webhook_url, params
    end

    # Updates an existing webhook
    def update(id, url=default_webhook_url)
      params = {:url => url}
      Mailgun.submit :put, webhook_url(id), params
    end

    # Deletes an existing webhook
    # Note: Deleting an Open or Click webhook will disable Open or Click tracking
    def delete(id)
      Mailgun.submit :delete, webhook_url(id)
    end

    private

    # Helper method to generate the proper url for Mailgun webhook API calls
    def webhook_url(id=nil)
      "#{@mailgun.base_url}/#{domain}/webhooks#{'/' + id if id}"
    end

  end
end
