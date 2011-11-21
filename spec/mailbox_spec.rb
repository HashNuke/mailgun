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

  describe "list mailboxes" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get).with("#{@mailgun.mailboxes.send(:mailbox_url, @mailbox_options[:domain])}", {}).and_return(sample_response)

      @mailgun.mailboxes.list @mailbox_options[:domain]
    end
  end

  describe "create mailbox" do
    it "should make a POST request with the right params"	do
      RestClient.should_receive(:post)
        .with("#{@mailgun.mailboxes.send(:mailbox_url, @mailbox_options[:domain])}",
        :mailbox  => @mailbox_options[:email],
        :password => @mailbox_options[:password])
        .and_return({})

      @mailgun.mailboxes.create(@mailbox_options[:email], @mailbox_options[:password])
    end
  end

  describe "update mailbox" do
    it "should make a PUT request with the right params" do
      RestClient.should_receive(:put)
        .with("#{@mailgun.mailboxes.send(:mailbox_url, @mailbox_options[:domain], @mailbox_options[:name])}",
        :password => @mailbox_options[:password])
        .and_return({})

      @mailgun.mailboxes.update_password @mailbox_options[:email],
      @mailbox_options[:password]
    end
  end

  describe "destroy mailbox" do
    it "should make a DELETE request with the right params" do
      RestClient.should_receive(:delete)
        .with("#{@mailgun.mailboxes.send(:mailbox_url, @mailbox_options[:domain], @mailbox_options[:name])}", {})
        .and_return({})

      @mailgun.mailboxes.destroy @mailbox_options[:email]
    end
  end
end
