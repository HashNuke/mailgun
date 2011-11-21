module Mailgun
  class Base
    attr_accessor :api_key,
                  :api_version,
                  :protocol,
                  :mailgun_host,
                  :use_test_mode

    # Options taken from
    # http://documentation.mailgun.net/quickstart.html#authentication
    # * Mailgun host - location of mailgun api servers
    # * Procotol - http or https [default to https]
    # * API key and version
    # * Test mode - if enabled, doesn't actually send emails (see http://documentation.mailgun.net/user_manual.html#sending-in-test-mode)
    def initialize(options)
      @mailgun_host = options.fetch(:mailgun_host) {"api.mailgun.net"}
      @protocol     = options.fetch(:protocol)     { "https"  }
      @api_version  = options.fetch(:api_version)  { "v2"  }
      @test_mode    = options.fetch(:test_mode)    { false }

      @api_key      = options.fetch(:api_key)      { raise ArgumentError(":api_key is a required argument to initialize Mailgun") }
    end

    # Returns the base url used in all Mailgun API calls
    def base_url
      "#{@protocol}://api:#{api_key}@#{mailgun_host}/#{api_version}"
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
      if e.http_body
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
end
