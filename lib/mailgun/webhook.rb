module Mailgun
  class Webhook
    # Used internally, called from Mailgun::Base
    # Used internally, called from Mailgun::Base
    def initialize(mailgun,domain)
      @mailgun = mailgun
      @domain  = domain
    end
    
    # List all domains on the account
    def list(domain=@domain)
      Mailgun.submit(:get, webhook_url(domain))["webhooks"] || []
    end

    
    # Find domain by name
    def find(event, domain=@domain)
      Mailgun.submit :get, webhook_url(domain, event)
    end

    # Add domain to account
    def create( opts, domain=@domain)
      Mailgun.submit :post, webhook_url(domain), opts
    end

     # Update domain by name
    def update(event, domain=@domain)
      Mailgun.submit :put, webhook_url(domain, event)
    end


    # Remves a domain from account
    def delete( event, domain=@domain)
      Mailgun.submit :delete, webhook_url(domain, event)
    end

    private

    # Helper method to generate the proper url for Mailgun domain API calls
    def webhook_url(domain,event = nil)
      "#{@mailgun.base_url}/domains/#{domain}/webhooks#{'/' + event if event}"
    end
    
    
  end
end