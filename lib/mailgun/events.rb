module Mailgun
	class Events
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain = domain
    end

    # List all events for a given domain
    def list(options={})
      Mailgun.submit(:get, events_url, options)
    end

    private

    def events_url
      "#{@mailgun.base_url}/#{@domain}/events"
    end
	end
end
