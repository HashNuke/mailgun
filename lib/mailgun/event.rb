module Mailgun
   class Events
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain = domain
    end

    # List all events for a given domain
    # * domain the domain for which all events will listed
    def list(options={})
      Mailgun.submit(:get, events_url, options)['items'] || []
    end

    private

    # Helper method to generate the proper url for Mailgun events API calls
    def events_url
      "#{@mailgun.base_url}/#{@domain}/events"
    end

   end
end