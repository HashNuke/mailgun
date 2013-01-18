require 'spec_helper'

describe Mailgun::Mailbox do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @sample = {
      :email  => "test@sample.mailgun.org",
      :mailbox_name => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list mailboxes" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      mailboxes_url = @mailgun.mailboxes(@sample[:domain]).send(:mailbox_url)

      Mailgun.should_receive(:submit).
        with(:get,mailboxes_url, {}).
        and_return(sample_response)

      @mailgun.mailboxes(@sample[:domain]).list
    end
  end

  describe "create mailbox" do
    it "should make a POST request with the right params"	do
      mailboxes_url = @mailgun.mailboxes(@sample[:domain]).send(:mailbox_url)
      Mailgun.should_receive(:submit)
        .with(:post, mailboxes_url,
          :mailbox  => @sample[:email],
          :password => @sample[:password])
        .and_return({})

      @mailgun.mailboxes(@sample[:domain]).create(@sample[:mailbox_name], @sample[:password])
    end
  end

  describe "update mailbox" do
    it "should make a PUT request with the right params" do
      mailboxes_url = @mailgun.mailboxes(@sample[:domain]).send(:mailbox_url, @sample[:mailbox_name])
      Mailgun.should_receive(:submit)
        .with(:put, mailboxes_url, :password => @sample[:password])
        .and_return({})

      @mailgun.mailboxes(@sample[:domain]).
        update_password(@sample[:mailbox_name], @sample[:password])
    end
  end

  describe "destroy mailbox" do
    it "should make a DELETE request with the right params" do
      mailboxes_url = @mailgun.mailboxes(@sample[:domain]).send(:mailbox_url, @sample[:name])
      Mailgun.should_receive(:submit)
        .with(:delete, mailboxes_url)
        .and_return({})

      @mailgun.mailboxes(@sample[:domain]).destroy(@sample[:name])
    end
  end
end
