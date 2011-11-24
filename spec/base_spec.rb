require 'spec_helper'

describe Mailgun::Base do

  before :each do
    @mailgun = Mailgun({:api_key => "some-junk-string"})

    @sample_options = {
      :api_key 	    => @mailgun.api_key,
      :api_version  => @mailgun.api_version,
      :protocol     => @mailgun.protocol,
      :mailgun_host => @mailgun.mailgun_host
    }
  end

  describe "Mailgun.new" do
    it "Mailgun() method should return a new Mailgun object" do
      @mailgun.should be_kind_of(Mailgun::Base)
    end

    it "should use https by default" do
      @mailgun.protocol.should == "https"
    end
  end


  
  describe "resources" do
    
    it "Mailgun#mailboxes should return an instance of Mailgun::Mailbox" do
      @mailgun.mailboxes.should be_kind_of(Mailgun::Mailbox)
    end

    it "Mailgun#routes should return an instance of Mailgun::Route" do
      @mailgun.routes.should be_kind_of(Mailgun::Route)
    end
  end


  
  describe "internal helper methods" do

    describe "Mailgun#base_url" do
      it "should return https url if use_https is true" do
      @mailgun.base_url.should == "https://api:#{@mailgun.api_key}@#{@mailgun.mailgun_host}/#{@mailgun.api_version}"
      end
    end

    describe "Mailgun.submit" do
      it "should send method and arguments to RestClient" do
        RestClient.should_receive(:test_method)
          .with({:arg1=>"val1"},{})
          .and_return({})
        Mailgun.submit :test_method, :arg1=>"val1"
      end
    end
    
  end
end
