module Mailgun
	class Log
    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    # List all logs for a given domain
    # * domain the domain for which all complaints will listed
    def list(domain=Mailgun.domain, limit=100, skip=0)
      response = Mailgun.submit :get, log_url(domain), {:limit => limit, :skip => skip}

      if response
        response["items"].collect {|item| item["message"]}
      end
    end
    
    private

    # Helper method to generate the proper url for Mailgun complaints API calls
    def log_url(domain)
      "#{@mailgun.base_url}/#{domain}/log"
    end
   
	end
end