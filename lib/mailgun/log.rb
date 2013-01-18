module Mailgun
	class Log
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain = domain
    end
    
    # List all logs for a given domain
    # * domain the domain for which all complaints will listed
    def list(options={})
      Mailgun.submit(:get, log_url, options)
    end
    
    private

    # Helper method to generate the proper url for Mailgun complaints API calls
    def log_url
      "#{@mailgun.base_url}/#{@domain}/log"
    end
   
	end
end