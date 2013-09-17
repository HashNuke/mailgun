module Mailgun
  class Event
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    # list events
    def list(parameters={})
      Mailgun.submit(:get, events_url, parameters)
    end
    
    # Helper method to generate the proper url for Mailgun event API calls
    def events_url(address=nil)
      puts "#{@mailgun.base_url}/#{@domain}/events#{'/' + address if address}"
      "#{@mailgun.base_url}/#{@domain}/events#{'/' + address if address}"
    end
  end
end
