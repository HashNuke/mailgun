module Mailgun
  class Bounce
    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    # List all bounces for a given domain
    # * domain the domain for which all bounces will listed
    def list(domain = Mailgun.domain)
      response = Mailgun.submit :get, bounce_url(domain)

      if response
        response["items"].collect {|item| item["address"]}
      end
    end

    def find(domain = Mailgun.domain, email)
      Mailgun.submit :get, bounce_url(domain, email)
    end

    def add(domain = Mailgun.domain, email)
      Mailgun.submit :post, bounce_url(domain), :address => email
    end

  #   def check_address_for_bounces
  # RestClient.get("https://api:key-3ax6xnjp29jd6fds4gc373sgvjxteol0"\
  #                "@api.mailgun.net/v2/samples.mailgun.org/bounces"\
  #                "/foo@bar.com"){|response, request, result| response }
  #   end
    
#     def add_bounce
#   RestClient.post("https://api:key-3ax6xnjp29jd6fds4gc373sgvjxteol0"\
#                   "@api.mailgun.net/v2/samples.mailgun.org/bounces",
#                   :address => 'ev@mgrules.com')
#     end

    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def bounce_url(domain, address=nil)
      domain = Mailgun.domain if Mailgun.domain
      "#{@mailgun.base_url}/#{domain}/bounces#{'/' + address if address}"
    end
    
  end
end