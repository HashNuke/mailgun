require 'spec_helper'

describe Mailgun::Address do

  before :each do
    @sample = "foo@mailgun.net"
  end

  describe "validate an address" do
    it "should require a public api key" do
      mailgun = Mailgun({:api_key => "api-key"})
      expect { mailgun.addresses }.to raise_error(ArgumentError, ":public_api_key is a required argument to validate addresses")
    end
    it "should make a GET request with correct params to find a given webhook" do
      mailgun = Mailgun({:api_key => "api-key", :public_api_key => "public-api-key"})

      sample_response = "{\"is_valid\":true,\"address\":\"foo@mailgun.net\",\"parts\":{\"display_name\":null,\"local_part\":\"foo\",\"domain\":\"mailgun.net\"},\"did_you_mean\":null}"
      validate_url = mailgun.addresses.send(:address_url, 'validate')

      expect(Mailgun).to receive(:submit).
        with(:get, validate_url, {:address => @sample}).
        and_return(sample_response)

      mailgun.addresses.validate(@sample)
    end
  end
end
