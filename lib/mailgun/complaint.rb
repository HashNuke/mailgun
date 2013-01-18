module Mailgun
  class Complaint
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end
    
    # List all complaints for domain
    def list
      Mailgun.submit(:get, complaint_url)["items"] || []
    end
    
    def find(email)
      Mailgun.submit :get, complaint_url(email)
    end

    def add(email)
      Mailgun.submit :post, complaint_url, {:address => email}
    end

    def destroy(email)
      Mailgun.submit :delete, complaint_url(email)
    end

    private

    # Helper method to generate the proper url for Mailgun complaints API calls
    def complaint_url(address=nil)
      "#{@mailgun.base_url}/#{@domain}/complaints#{'/' + address if address}"
    end

  end
end