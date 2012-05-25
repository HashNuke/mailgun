module Mailgun
	class List
    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end
    

    ## List functionality

    # TODO add default domain functionality for the address names of lists

    # List all mailing lists 
    def all
      response = Mailgun.submit :get, list_url

      if response
        response["items"].collect {|item| item["address"]}
      end
    end

    # List a single mailing list by a given address
    def find(address)
      Mailgun.submit :get, list_url(address)
    end

    # Create a mailing list with a given address
    # with an optional name and description
    def create(address, name=nil, description=nil)
    	params = {:address => address}
    	params[:name] = name if name
    	params[:description] = description if description
      Mailgun.submit :post, list_url, params
    end

    # Update a mailing list with a given address
    # with an optional new address, name or description
    def update(address, new_address, name=nil, description=nil)
     	params = {:address => new_address}
    	params[:name] = name if name
    	params[:description] = description if description
      Mailgun.submit :put, list_url(address), params
    end		

    # Deletes a mailing list with a given address
    def delete(address)
    	Mailgun.submit :delete, list_url(address)
    end


    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def list_url(address=nil)
      "#{@mailgun.base_url}/lists#{'/' + address if address}"
    end
    
	end
end