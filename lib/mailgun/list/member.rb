module Mailgun
  # List Member functionality
  # Refer Mailgun docs for optional params
  class MailingList::Member

    # Used internally, called from Mailgun::Base
    def initialize(mailgun, address)
      @mailgun = mailgun
      @address = address
    end

    # List all mailing list members
    def list(options={})
      response = Mailgun.submit(:get, list_member_url, options)["items"]
    end

    # List a single mailing list member by a given address
    def find(member_address)
      Mailgun.submit :get, list_member_url(member_address)
    end


    # Adds a mailing list member with a given address
    # NOTE Use create instead of add?
    def add(member_address, options={})
      params = {:address => member_address}
      Mailgun.submit :post, list_member_url, params.merge(options)
    end

    # TODO add spec?
    alias_method :create, :add

    # Update a mailing list member with a given address
    def update(member_address, options={})
      params = {:address => member_address}
      Mailgun.submit :put, list_member_url(member_address), params.merge(options)
    end   

    # Deletes a mailing list member with a given address
    def remove(member_address)
      Mailgun.submit :delete, list_member_url(member_address)
    end


    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def list_member_url(member_address=nil)
      "#{@mailgun.base_url}/lists#{'/' + @address}/members#{'/' + member_address if member_address}"
    end
    
  end
end