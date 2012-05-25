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

  describe "find bounces" do
    it "should make a GET request with correct params to find given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get)
      .with("#{@mailgun.bounces.send(:bounce_url, @bounce_options[:domain], @bounce_options[:email])}", {})
      .and_return(sample_response)

      @mailgun.bounces.find(@bounce_options[:domain], @bounce_options[:email])
    end
  end

  describe "add bounces" do
    it "should make a POST request with correct params to add a given email address" do
      #sample_response = "{\"message\"=>\"Address has been added to the bounces table\", \"address\"=>\"#{@bounce_options[:email]}\"}"
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:post)
      .with("#{@mailgun.bounces.send(:bounce_url, @bounce_options[:domain])}", {:address => @bounce_options[:email]})
      .and_return(sample_response)

      @mailgun.bounces.add(@bounce_options[:domain], @bounce_options[:email])
    end
  end

end
