require 'spec_helper'

describe Mailgun::Log do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @sample = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list log" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      log_url = @mailgun.log(@sample[:domain]).send(:log_url)
      Mailgun.should_receive(:submit).
        with(:get, log_url, {}).
        and_return(sample_response)

      @mailgun.log(@sample[:domain]).list
    end
  end

end