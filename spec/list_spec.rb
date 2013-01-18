require 'spec_helper'

describe Mailgun::MailingList do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @sample = {
      :email      => "test@sample.mailgun.org",
      :list_email => "dev@samples.mailgun.org",
      :name       => "test",
      :domain     => "sample.mailgun.org"
    }
  end

  describe "list mailing lists" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      Mailgun.should_receive(:submit)
      .with(:get, "#{@mailgun.lists.send(:list_url)}", {}).and_return(sample_response)
    
      @mailgun.lists.list
    end
  end

  describe "find list adress" do
    it "should make a GET request with correct params to find given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      Mailgun.should_receive(:submit)
      .with(:get, "#{@mailgun.lists.send(:list_url, @sample[:list_email])}")
      .and_return(sample_response)

      @mailgun.lists.find(@sample[:list_email])
    end
  end

  describe "create list" do
    it "should make a POST request with correct params to add a given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      Mailgun.should_receive(:submit)
      .with(:post, "#{@mailgun.lists.send(:list_url)}", {:address => @sample[:list_email]})
      .and_return(sample_response)

      @mailgun.lists.create(@sample[:list_email])
    end
  end

  describe "update list" do
    it "should make a PUT request with correct params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      Mailgun.should_receive(:submit)
      .with(:put, "#{@mailgun.lists.send(:list_url, @sample[:list_email])}", {:address => @sample[:email]})
      .and_return(sample_response)

      @mailgun.lists.update(@sample[:list_email], @sample[:email])
    end
  end

  describe "delete list" do
    it "should make a DELETE request with correct params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      Mailgun.should_receive(:submit)
      .with(:delete, "#{@mailgun.lists.send(:list_url, @sample[:list_email])}")
      .and_return(sample_response)

      @mailgun.lists.delete(@sample[:list_email])
    end
  end

end
