module Mailgun
  class Base
    # Options taken from
    # http://documentation.mailgun.net/quickstart.html#authentication
    # * Mailgun host - location of mailgun api servers
    # * Procotol - http or https [default to https]
    # * API key and version
    # * Test mode - if enabled, doesn't actually send emails (see http://documentation.mailgun.net/user_manual.html#sending-in-test-mode)
    # * Domain - domain to use
    # * Webhook URL - default url to use if one is not specified in each request
    # * Public API Key - used for address endpoint
    def initialize(options)
      Mailgun.mailgun_host    = options.fetch(:mailgun_host)    { "api.mailgun.net" }
      Mailgun.protocol        = options.fetch(:protocol)        { "https" }
      Mailgun.api_version     = options.fetch(:api_version)     { "v3" }
      Mailgun.test_mode       = options.fetch(:test_mode)       { false }
      Mailgun.api_key         = options.fetch(:api_key)         { raise ArgumentError.new(":api_key is a required argument to initialize Mailgun") if Mailgun.api_key.nil? }
      Mailgun.domain          = options.fetch(:domain)          { nil }
      Mailgun.webhook_url     = options.fetch(:webhook_url)     { nil }
      Mailgun.public_api_key  = options.fetch(:public_api_key)  { nil }
    end

    # Returns the base url used in all Mailgun API calls
    def base_url
      "#{Mailgun.protocol}://api:#{Mailgun.api_key}@#{Mailgun.mailgun_host}/#{Mailgun.api_version}"
    end

    def public_base_url
      "#{Mailgun.protocol}://api:#{Mailgun.public_api_key}@#{Mailgun.mailgun_host}/#{Mailgun.api_version}"
    end

    # Returns an instance of Mailgun::Mailbox configured for the current API user
    def mailboxes(domain = Mailgun.domain)
      Mailgun::Mailbox.new(self, domain)
    end

    def messages(domain = Mailgun.domain)
      @messages ||= Mailgun::Message.new(self, domain)
    end

    def routes
      @routes ||= Mailgun::Route.new(self)
    end

    def bounces(domain = Mailgun.domain)
      Mailgun::Bounce.new(self, domain)
    end

    def domains
      Mailgun::Domain.new(self)
    end

    def unsubscribes(domain = Mailgun.domain)
      Mailgun::Unsubscribe.new(self, domain)
    end

    def webhooks(domain = Mailgun.domain, webhook_url = Mailgun.webhook_url)
      Mailgun::Webhook.new(self, domain, webhook_url)
    end

    def addresses(domain = Mailgun.domain)
      if Mailgun.public_api_key.nil?
        raise ArgumentError.new(":public_api_key is a required argument to validate addresses")
      end
      Mailgun::Address.new(self)
    end

    def complaints(domain = Mailgun.domain)
      Mailgun::Complaint.new(self, domain)
    end

    def log(domain=Mailgun.domain)
      Mailgun::Log.new(self, domain)
    end

    def lists
      @lists ||= Mailgun::MailingList.new(self)
    end

    def list_members(address)
      Mailgun::MailingList::Member.new(self, address)
    end

    def secure
      Mailgun::Secure.new(self)
    end
  end


  # Submits the API call to the Mailgun server
  def self.submit(method, url, parameters={})
    begin
      JSON.parse(Client.new(url).send(method, parameters))
    rescue => e
      error_code = e.http_code
      error_message = JSON(e.http_body)["message"]
      error = Mailgun::Error.new(
        :code => error_code || nil,
        :message => error_message || nil
      )
      if error.handle.kind_of? Mailgun::ErrorBase
        raise error.handle
      else
        raise error
      end
    end
  end

  #
  # @TODO Create root module to give this a better home
  #
  class << self
    attr_accessor :api_key,
                  :api_version,
                  :protocol,
                  :mailgun_host,
                  :test_mode,
                  :domain,
                  :webhook_url,
                  :public_api_key

    def configure
      yield self
      true
    end
    alias :config :configure
  end
end
