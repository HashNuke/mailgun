module Mailgun

  # Interface to manage domains
  class Domain

    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    # List all domains on the account
    def list(options={})
      Mailgun.submit(:get, domain_url, options)["items"] || []
    end

    # Find domain by name
    def find(domain)
      Mailgun.submit :get, domain_url(domain)
    end

    # Add domain to account
    def create(domain, opts = {})
      opts = {name: domain}.merge(opts)
      Mailgun.submit :post, domain_url, opts
    end

    # Remves a domain from account
    def delete(domain)
      Mailgun.submit :delete, domain_url(domain)
    end

    private

    # Helper method to generate the proper url for Mailgun domain API calls
    def domain_url(domain = nil)
      "#{@mailgun.base_url}/domains#{'/' + domain if domain}"
    end
    
  end
end