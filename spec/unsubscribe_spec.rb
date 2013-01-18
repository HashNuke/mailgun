require 'spec_helper'

describe Mailgun::Unsubscribe do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @sample = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org",
      :tag   => 'tag1' 
    }
  end

  describe "list unsubscribes" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      unsubscribes_url = @mailgun.unsubscribes(@sample[:domain]).send(:unsubscribe_url)
      Mailgun.should_receive(:submit).
        with(:get, unsubscribes_url, {}).
        and_return(sample_response)

      @mailgun.unsubscribes(@sample[:domain]).list
    end
  end

  describe "find unsubscribe" do
    it "should make a GET request with the right params to find given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      unsubscribes_url = @mailgun.unsubscribes(@sample[:domain]).send(:unsubscribe_url, @sample[:email])

      Mailgun.should_receive(:submit)
        .with(:get, unsubscribes_url)
        .and_return(sample_response)

      @mailgun.unsubscribes(@sample[:domain]).find(@sample[:email])
    end
  end

  describe "delete unsubscribe" do
    it "should make a DELETE request with correct params to remove a given email address" do
      response_message = "{\"message\"=>\"Unsubscribe event has been removed\", \"address\"=>\"#{@sample[:email]}\"}"
      unsubscribes_url = @mailgun.unsubscribes(@sample[:domain]).send(:unsubscribe_url, @sample[:email])

      Mailgun.should_receive(:submit)
        .with(:delete, unsubscribes_url)
        .and_return(response_message)

      @mailgun.unsubscribes(@sample[:domain]).remove(@sample[:email])
    end
  end

  describe "add unsubscribe" do
    context "to tag" do
      it "should make a POST request with correct params to add a given email address to unsubscribe from a tag" do
        response_message = "{\"message\"=>\"Address has been added to the unsubscribes table\", \"address\"=>\"#{@sample[:email]}\"}"
        Mailgun.should_receive(:submit)
          .with(:post, "#{@mailgun.unsubscribes(@sample[:domain]).send(:unsubscribe_url)}",{:address=>@sample[:email], :tag=>@sample[:tag]})
          .and_return(response_message)

        @mailgun.unsubscribes(@sample[:domain]).add(@sample[:email], @sample[:tag])
      end
    end

    context "on all" do
      it "should make a POST request with correct params to add a given email address to unsubscribe from all tags" do
        sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
        unsubscribes_url = @mailgun.unsubscribes(@sample[:domain]).send(:unsubscribe_url)

        Mailgun.should_receive(:submit)
          .with(:post, unsubscribes_url, {
            :address => @sample[:email], :tag => '*'
          })
          .and_return(sample_response)

        @mailgun.unsubscribes(@sample[:domain]).add(@sample[:email])
      end
    end
  end

end
