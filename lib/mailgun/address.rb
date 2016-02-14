module Mailgun
  # https://documentation.mailgun.com/api-email-validation.html#email-validation
  class Address
    # Used internally, called from Mailgun::Base
    def initialize(mailgun)
      @mailgun = mailgun
    end

    # Given an arbitrary address, validates address based off defined checks
    def validate(email)
      Mailgun.submit :get, address_url('validate'), {:address => email}
    end

    private

    def address_url(action)
      "#{@mailgun.public_base_url}/address/#{action}"
    end
  end
end
