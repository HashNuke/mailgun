require 'spec_helper'

describe Mailgun::List::Member do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @list_member_options = {
      :email      => "test@sample.mailgun.org",
      :list_email => "test_list@sample.mailgun.org",
      :name       => "test",
      :domain     => "sample.mailgun.org"
    }
  end

  describe "list members" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get).with("#{@mailgun.list_members.send(:list_member_url, @list_member_options[:list_email])}", {}).and_return(sample_response)
    
      @mailgun.list_members.list @list_member_options[:list_email]
    end
  end

  describe "find member in list" do
    it "should make a GET request with correct params to find given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get)
      .with("#{@mailgun.list_members.send(:list_member_url, @list_member_options[:list_email], @list_member_options[:email])}", {})
      .and_return(sample_response)

      @mailgun.list_members.find(@list_member_options[:list_email], @list_member_options[:email])
    end
  end

  describe "add member to list" do
    it "should make a POST request with correct params to add a given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:post)
      .with("#{@mailgun.list_members.send(:list_member_url, @list_member_options[:list_email])}", {
        :address => @list_member_options[:email], :subscribed => 'yes', :upsert => 'no'
      }).and_return(sample_response)

      @mailgun.list_members.add(@list_member_options[:list_email], @list_member_options[:email])
    end
  end

  describe "update member in list" do
    it "should make a PUT request with correct params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:put)
      .with("#{@mailgun.list_members.send(:list_member_url, @list_member_options[:list_email], @list_member_options[:email])}", {
        :address => @list_member_options[:email], :subscribed => 'yes'
      }).and_return(sample_response)

      @mailgun.list_members.update(@list_member_options[:list_email], @list_member_options[:email])
    end
  end

  describe "delete member from list" do
    it "should make a DELETE request with correct params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:delete)
      .with("#{@mailgun.list_members.send(:list_member_url, @list_member_options[:list_email], @list_member_options[:email])}", {})
      .and_return(sample_response)

      @mailgun.list_members.remove(@list_member_options[:list_email], @list_member_options[:email])
    end
  end

end
