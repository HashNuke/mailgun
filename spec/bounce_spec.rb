require 'spec_helper'

describe Mailgun::Mailbox do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @mailbox_options = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list bounces" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get).with("#{@mailgun.mailboxes.send(:mailbox_url, @mailbox_options[:domain])}", {}).and_return(sample_response)

      @mailgun.bounces.list @mailbox_options[:domain]
    end
  end

end
