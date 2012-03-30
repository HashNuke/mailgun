module Mailgun
  class Bounce
    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    # List all mailboxes for a given domain
    # * domain the domain for which all mailboxes will listed
    def list(domain)
      response = Mailgun.submit :get, bounce_url(domain)

      if response
        response["items"].collect {|item| item["address"]}
      end
    end
    
    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def bounce_url(domain, address=nil)
      "#{@mailgun.base_url}/#{domain}/bounces#{'/' + address if address}"
    end
    
  end
end