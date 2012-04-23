module Mailgun
  class Complaint
    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    # List all complaints for a given domain
    # * domain the domain for which all complaints will listed
    def list(domain = Mailgun.domain)
      response = Mailgun.submit :get, complaint_url(domain)

      if response
        response["items"].collect {|item| item["address"]}
      end
    end
    
    private

    # Helper method to generate the proper url for Mailgun complaints API calls
    def complaint_url(domain, address=nil)
      "#{@mailgun.base_url}/#{domain}/complaints#{'/' + address if address}"
    end
    
  end
end