module Mailgun
  class List::Member
    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    ## List Member functionality

    # List all mailing list members
    # TODO add parameters: subscribed, limit, skip
    def list(address)
      response = Mailgun.submit :get, list_member_url(address)

      if response
        response["items"].collect {|item| item["address"]}
      end
    end

    # List a single mailing list member by a given address
    def find(address, member_address)
      Mailgun.submit :get, list_member_url(address, member_address)
    end

    # Adds a mailing list member with a given address
    # TODO add name, vars, subscribed, upsert
    def add(address, member_address, name=nil, vars={}, subscribed='yes', upsert='no')
      params = {:address => member_address, :subscribed => subscribed, :upsert => 'no'}
      params[:name] = name if name
      params[:vars] = vars unless vars.empty?
      Mailgun.submit :post, list_member_url(address), params
    end

    # Update a mailing list member with a given address
    # with an optional new member_address, name, vars and subscribed
    def update(address, member_address, name=nil, vars={}, subscribed='yes')
      params = {:address => member_address, :subscribed => subscribed}
      params[:name] = name if name
      params[:vars] = vars unless vars.empty?
      Mailgun.submit :put, list_member_url(address, member_address), params
    end   

    # Deletes a mailing list member with a given address
    def remove(address, member_address)
      Mailgun.submit :delete, list_member_url(address, member_address)
    end


    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def list_member_url(address, member_address=nil)
      "#{@mailgun.base_url}/lists#{'/' + address}/members#{'/' + member_address if member_address}"
    end
    
  end
end