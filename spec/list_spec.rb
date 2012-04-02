require 'spec_helper'

describe Mailgun::List do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @list_options = {
      :email      => "test@sample.mailgun.org",
      :list_email => "dev@samples.mailgun.org",
      :name       => "test",
      :domain     => "sample.mailgun.org"
    }
  end

  describe "all list" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get)
      .with("#{@mailgun.lists.send(:list_url)}", {}).and_return(sample_response)
    
      @mailgun.lists.all
    end
  end

  describe "find list adress" do
    it "should make a GET request with correct params to find given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get)
      .with("#{@mailgun.lists.send(:list_url, @list_options[:list_email])}", {})
      .and_return(sample_response)

      @mailgun.lists.find(@list_options[:list_email])
    end
  end

  describe "create list" do
    it "should make a POST request with correct params to add a given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:post)
      .with("#{@mailgun.lists.send(:list_url)}", {:address => @list_options[:list_email]})
      .and_return(sample_response)

      @mailgun.lists.create(@list_options[:list_email])
    end
  end

  describe "update list" do
    it "should make a PUT request with correct params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:put)
      .with("#{@mailgun.lists.send(:list_url, @list_options[:list_email])}", {:address => @list_options[:email]})
      .and_return(sample_response)

      @mailgun.lists.update(@list_options[:list_email], @list_options[:email])
    end
  end

  describe "delete list" do
    it "should make a DELETE request with correct params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:delete)
      .with("#{@mailgun.lists.send(:list_url, @list_options[:list_email])}", {})
      .and_return(sample_response)

      @mailgun.lists.delete(@list_options[:list_email])
    end
  end

end
