require 'spec_helper'

describe Mailgun::Unsubscribe do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @unsubscribe_options = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list unsubscribes" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get).with("#{@mailgun.unsubscribes.send(:unsubscribe_url, @unsubscribe_options[:domain])}", {}).and_return(sample_response)

      @mailgun.unsubscribes.list @unsubscribe_options[:domain]
    end
  end

end
