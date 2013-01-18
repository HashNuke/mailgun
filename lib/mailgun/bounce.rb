module Mailgun

  # Interface to manage bounce lists
  # Refer - http://documentation.mailgun.net/api-bounces.html for optional params to pass
  class Bounce
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end
    
    # List all bounces for a given domain
    def list(options={})
      Mailgun.submit(:get, bounce_url, options)["items"] || []
    end

    # Find bounce events for an email address
    def find(email)
      Mailgun.submit :get, bounce_url(email)
    end

    def add(email)
      Mailgun.submit :post, bounce_url, :address => email
    end

    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def bounce_url(address=nil)
      "#{@mailgun.base_url}/#{@domain}/bounces#{'/' + address if address}"
    end
    
  end
end