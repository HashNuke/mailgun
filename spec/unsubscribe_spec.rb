require 'spec_helper'

describe Mailgun::Unsubscribe do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @unsubscribe_options = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org",
      :tag   => 'tag1' 
    }
  end

  describe "list unsubscribes" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get).with("#{@mailgun.unsubscribes.send(:unsubscribe_url, @unsubscribe_options[:domain])}", {}).and_return(sample_response)

      @mailgun.unsubscribes.list @unsubscribe_options[:domain]
    end
  end

  describe "find unsubscribe" do
    it "should make a GET request with the right params to find given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get)
      .with("#{@mailgun.unsubscribes.send(:unsubscribe_url, @unsubscribe_options[:domain], @unsubscribe_options[:email])}", {})
      .and_return(sample_response)

      @mailgun.unsubscribes.find(@unsubscribe_options[:domain], @unsubscribe_options[:email])
    end
  end

  describe "delete unsubscribe" do
    it "should make a DELETE request with correct params to remove a given email address" do
      response_message = "{\"message\"=>\"Unsubscribe event has been removed\", \"address\"=>\"#{@unsubscribe_options[:email]}\"}"
      Mailgun.should_receive(:submit)
      .with(:delete, "#{@mailgun.unsubscribes.send(:unsubscribe_url, @unsubscribe_options[:domain], @unsubscribe_options[:email])}")
      .and_return(response_message)

      @mailgun.unsubscribes.remove(@unsubscribe_options[:domain], @unsubscribe_options[:email])
    end
  end

  describe "add unsubscribe" do
    context "to tag" do
      it "should make a POST request with correct params to add a given email address to unsubscribe from a tag" do
        response_message = "{\"message\"=>\"Address has been added to the unsubscribes table\", \"address\"=>\"#{@unsubscribe_options[:email]}\"}"
        Mailgun.should_receive(:submit)
        .with(:post, "#{@mailgun.unsubscribes.send(:unsubscribe_url, @unsubscribe_options[:domain])}",{:address=>@unsubscribe_options[:email], :tag=>@unsubscribe_options[:tag]})
        .and_return(response_message)
        @mailgun.unsubscribes.add(@unsubscribe_options[:email], @unsubscribe_options[:domain],  @unsubscribe_options[:tag])
      end
    end

    context "on all" do
      it "should make a POST request with correct params to add a given email address to unsubscribe from all tags" do
        sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
        RestClient.should_receive(:post)
        .with("#{@mailgun.unsubscribes.send(:unsubscribe_url, @unsubscribe_options[:domain])}", {
          :address => @unsubscribe_options[:email], :tag => '*'
        })
        .and_return(sample_response)

        @mailgun.unsubscribes.add(@unsubscribe_options[:email], @unsubscribe_options[:domain])
      end
    end
  end

end
