module Mailgun
  class Validation
    # Used internally, called from Mailgun::Base
    # Used internally, called from Mailgun::Base
    def initialize(mailgun,domain)
      @mailgun = mailgun
      @domain  = domain
    end




    # validate Mailgun API
    def get_validate(hash={})
      Mailgun.submit :get, validate_url('validate',hash)
    end

    # validate Mailgun API
    def get_parse(hash={})
      Mailgun.submit :get, validate_url('parse')
    end



    private

    # Helper method to generate the proper url for Mailgun domain API calls
    def validate_url(method,hash)
      paramitors = hash.collect {|k, v| "#{k.to_s}=#{CGI::escape(v.to_s)}"}.join("&")
      "#{@mailgun.pub_url}/address/#{method}?#{paramitors}"
    end


  end
end