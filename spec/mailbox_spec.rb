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
    it "should make a get request with the right params" do
      sample_response = "{\n  \"total_count\": 1,\n  \"items\": [\n  {\n  \"size_bytes\": 0,\n  \"mailbox\": \"postmaster@bsample.mailgun.com\"\n    }\n  ]\n}"
      RestClient.should_receive(:get).with("#{@mailgun.send(:base_url)}/#{@mailbox_options[:domain]}/mailboxes", {}).and_return(sample_response)

      @mailgun.mailboxes.list @mailbox_options[:domain]
    end
  end

  describe "create mailbox" do
    it "should make a post request with the right params"	do
      RestClient.should_receive(:post)
        .with("#{@mailgun.send(:base_url)}/#{@mailbox_options[:domain]}/mailboxes",
        :mailbox  => @mailbox_options[:email],
        :password => @mailbox_options[:password])
        .and_return({})

      @mailgun.mailboxes.create(@mailbox_options[:email], @mailbox_options[:password])
    end
  end

  describe "update mailbox password" do
    it "should make a put request with the right params" do
      RestClient.should_receive(:put)
        .with("#{@mailgun.send(:base_url)}/#{@mailbox_options[:domain]}/mailboxes/#{@mailbox_options[:name]}",
        :password => @mailbox_options[:password])
        .and_return({})

      @mailgun.mailboxes.update_password @mailbox_options[:email],
      @mailbox_options[:password]
    end
  end

  describe "destroy mailbox" do
    it "should make a put request with the right params" do
      RestClient.should_receive(:delete)
        .with("#{@mailgun.send(:base_url)}/#{@mailbox_options[:domain]}/mailboxes/#{@mailbox_options[:name]}", {})
        .and_return({})

      @mailgun.mailboxes.destroy @mailbox_options[:email]
    end
  end
end
