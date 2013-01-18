module Mailgun

  # Complaints interface. Refer to http://documentation.mailgun.net/api-complaints.html
  class Complaint
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end
    
    # List all the users who have complained
    def list(options={})
      Mailgun.submit(:get, complaint_url, options)["items"] || []
    end

    # Find a complaint by email
    def find(email)
      Mailgun.submit :get, complaint_url(email)
    end

    # Add an email to the complaints list
    def add(email)
      Mailgun.submit :post, complaint_url, {:address => email}
    end

    # Removes a complaint by email
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