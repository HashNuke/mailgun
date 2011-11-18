module Mailgun
  class Mailbox

    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end

    # List all mailboxes for a given domain
    # * domain the domain for which all mailboxes will listed
    def list(domain)
      response = submit :get, mailbox_url(domain)
      response["items"].collect {|item| item["mailbox"]}
    end
    

    # Creates a mailbox on the Mailgun server with the given password
    def create(address, password)
      submit :post, mailbox_url(address.split("@").last), :mailbox =>  address,
      :password => password
    end


    # Sets the password for a mailbox
    def update_password(address, password)
      mailbox_name, domain = address.split("@")

      submit :put, mailbox_url(domain, mailbox_name), :password => password
    end


    # Destroys the mailbox
    def destroy(address)
      mailbox_name, domain = address.split("@")

      submit :delete,  mailbox_url(domain, mailbox_name)
    end


    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def mailbox_url(domain, mailbox_name=nil)
      "#{@mailgun.base_url}/#{domain}/mailboxes#{'/' + mailbox_name if mailbox_name}"
    end


    # Submits the API call to the Mailgun server
    def submit(method, url, parameters={})
      JSON(RestClient.send(method, url, parameters))
    end
  end
end
