module Mailgun
  class Unsubscribe
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end
    
    # List all unsubscribes for the domain
    def list(options={})
      Mailgun.submit(:get, unsubscribe_url, options)["items"]
    end

    def find(email)
      Mailgun.submit :get, unsubscribe_url(email)
    end

    def add(email, tag='*')
      Mailgun.submit :post, unsubscribe_url, {:address => email, :tag => tag}
    end

    def remove(email)
      Mailgun.submit :delete, unsubscribe_url(email)
    end
    
    private

    # Helper method to generate the proper url for Mailgun unsubscribe API calls
    def unsubscribe_url(address=nil)
      "#{@mailgun.base_url}/#{@domain}/unsubscribes#{'/' + address if address}"
    end
    
  end
end