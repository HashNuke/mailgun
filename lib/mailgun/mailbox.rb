require "rest-client"
require "keyword_params"

module Mailgun
  class Mailbox
    def initialize(api_key)
      @api_key = api_key
    end

    def list_mailboxes(domain)
      api_call = RestClient.get "#{Mailgun.base_url(api_key)}/#{domain}/mailboxes"
    end
    
    def create_mailbox(options)
      mailbox_name = options.fetch(:name) { raise ArgumentError }
      password = options.fetch(:password) { raise ArgumentError }
      domain = options.fetch(:domain) { raise ArgumentError }
      full_mailbox_name = "#{name}@#{domain}"
      api_call = RestClient.post "#{Mailgun.base_url(api_key)}/#{domain}/mailboxes", :mailbox => full_mailbox_name, :password => password
    end

    def update_mailbox_password(options)
      mailbox_name = options.fetch(:name) {raise ArgumentError }
      domain = options.fetch(:domain) {raise ArgumentError }
      password = options.fetch(:password) {raise ArgumentError }

      api_call = RestClient.put "#{Mailgun.base_url(api_key)}/#{domain}/mailboxes/#{mailbox_name}", :password => password
    end

    def delete_mailbox(options)
      mailbox_name = options.fetch(:name) {raise ArgumentError }
      domain = options.fetch(:domain) {raise ArgumentError }

      api_call = RestClient.delete "#{Mailgun.base_url(api_key)}/#{domain}/mailboxes/#{mailbox_name}"
    end
  end
end
