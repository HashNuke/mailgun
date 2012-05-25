require 'spec_helper'

describe Mailgun::Bounce do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @bounce_options = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list bounces" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get).with("#{@mailgun.bounces.send(:bounce_url, @bounce_options[:domain])}", {}).and_return(sample_response)
    
      @mailgun.bounces.list @bounce_options[:domain]
    end
  end

end
