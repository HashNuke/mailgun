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
    #
    # @param options [Hash] options to populate to mailgun find
    # @option options limit (100) [Integer] limit of results
    # @option options skip  (0)   [Integer] number of results to skip
    #
    # @returns [Array<Hash>] array of bouces
    def list(options={})
      Mailgun.submit(:get, bounce_url, options)["items"] || []
    end

    # Find bounce events for an email address
    #
    # @returns [<Hash>] found bouce
    def find(email)
      Mailgun.submit :get, bounce_url(email)
    end

    # Creates a bounce for an email address
    #
    # @param email [String] email address to bounce
    # @param options [Hash] options to populate to mailgun bounce creation
    # @option options code (550) [Integer] Error code
    # @option options error  ('')   [String] Error description
    #
    # @returns [<Hash>] created bouce
    def add(email, options={})
      Mailgun.submit :post, bounce_url, {:address => email}.merge(options)
    end
    
    # Cleans the bounces for an email address
    def destroy(email)
      Mailgun.submit :delete, bounce_url(email)  
    end

    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def bounce_url(address=nil)
      "#{@mailgun.base_url}/#{@domain}/bounces#{'/' + address if address}"
    end
    
  end
end
