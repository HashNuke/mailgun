module Mailgun
  class Base
    # Options taken from
    # http://documentation.mailgun.net/quickstart.html#authentication
    # * Mailgun host - location of mailgun api servers
    # * Procotol - http or https [default to https]
    # * API key and version
    # * Test mode - if enabled, doesn't actually send emails (see http://documentation.mailgun.net/user_manual.html#sending-in-test-mode)
    def initialize(options)
      Mailgun.mailgun_host = options.fetch(:mailgun_host) {"api.mailgun.net"}
      Mailgun.protocol     = options.fetch(:protocol)     { "https"  }
      Mailgun.api_version  = options.fetch(:api_version)  { "v2"  }
      Mailgun.test_mode    = options.fetch(:test_mode)    { false }
      Mailgun.api_key      = options.fetch(:api_key)      { raise ArgumentError.new(":api_key is a required argument to initialize Mailgun") if Mailgun.api_key.nil?}
    end

    # Returns the base url used in all Mailgun API calls
    def base_url
      "#{Mailgun.protocol}://api:#{Mailgun.api_key}@#{Mailgun.mailgun_host}/#{Mailgun.api_version}"
    end

    # Returns an instance of Mailgun::Mailbox configured for the current API user
    def mailboxes
      @mailboxes ||= Mailgun::Mailbox.new(self)
    end

    def routes
      @routes ||= Mailgun::Route.new(self)
    end
  end


  # Submits the API call to the Mailgun server
  def self.submit(method, url, parameters={})
    begin
      return JSON(RestClient.send(method, url, parameters))
    rescue => e
      error_message = nil
      if e.respond_to? :http_body
        begin
          error_message = JSON(e.http_body)["message"]
        rescue
          raise e
        end
        raise Mailgun::Error.new(error_message)
      end
      raise e
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
                  :domain

    def configure
      yield self
      true
    end
    alias :config :configure
  end
end
