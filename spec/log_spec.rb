require 'spec_helper'

describe Mailgun::Log do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @log_options = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list log" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      Mailgun.should_receive(:submit).
        with(:get, "#{@mailgun.log.send(:log_url, @log_options[:domain])}", {}).
        and_return(sample_response)

      @mailgun.log.list @log_options[:domain]
    end
  end

end