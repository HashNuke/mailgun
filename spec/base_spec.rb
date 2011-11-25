require 'spec_helper'

describe Mailgun::Base do

  it "should raise an error if the api_key has not been set" do
    expect do
      Mailgun()
    end.should raise_error ArgumentError
  end

  it "can be called directly if the api_key has been set via Mailgun.configure" do
    Mailgun.config { |c| c.api_key = "some-junk-string" }
    expect do
      Mailgun()
    end.should_not raise_error ArgumentError
  end

  it "can be instanced with the api_key as a param" do
    expect do
      Mailgun({:api_key => "some-junk-string"})
    end.should_not raise_error ArgumentError
  end

  describe "Mailgun.new" do
    it "Mailgun() method should return a new Mailgun object" do
      mailgun = Mailgun({:api_key => "some-junk-string"})
      mailgun.should be_kind_of(Mailgun::Base)
    end
  end

  describe "resources" do
    before :each do
      @mailgun = Mailgun({:api_key => "some-junk-string"})
    end

    it "Mailgun#mailboxes should return an instance of Mailgun::Mailbox" do
      @mailgun.mailboxes.should be_kind_of(Mailgun::Mailbox)
    end

    it "Mailgun#routes should return an instance of Mailgun::Route" do
      @mailgun.routes.should be_kind_of(Mailgun::Route)
    end
  end


  
  describe "internal helper methods" do
    before :each do
      @mailgun = Mailgun({:api_key => "some-junk-string"})
    end

    describe "Mailgun#base_url" do
      it "should return https url if use_https is true" do
      @mailgun.base_url.should == "https://api:#{Mailgun.api_key}@#{Mailgun.mailgun_host}/#{Mailgun.api_version}"
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

  describe "configuration" do
    describe "default settings" do
      it "api_version is v2" do
        Mailgun.api_version.should eql 'v2'
      end
      it "should use https by default" do
        Mailgun.protocol.should == "https"
      end
      it "mailgun_host is 'api.mailgun.net'" do
        Mailgun.mailgun_host.should eql 'api.mailgun.net'
      end

      it "test_mode is false" do
        Mailgun.test_mode.should eql false
      end

      it "domain is not set" do
        Mailgun.domain.should be_nil
      end
    end

    describe "setting configurations" do
      before(:each) do
        Mailgun.configure do |c|
          c.api_key = 'some-api-key'
          c.api_version = 'v2'
          c.protocol = 'https'
          c.mailgun_host = 'api.mailgun.net'
          c.test_mode = false
          c.domain = 'some-domain'
        end
      end

      it "allows me to set my API key easily" do
        Mailgun.api_key.should eql 'some-api-key'
      end

      it "allows me to set the api_version attribute" do
        Mailgun.api_version.should eql 'v2'
      end

      it "allows me to set the protocol attribute" do
        Mailgun.protocol.should eql 'https'
      end
      
      it "allows me to set the mailgun_host attribute" do
        Mailgun.mailgun_host.should eql 'api.mailgun.net'
      end
      it "allows me to set the test_mode attribute" do
        Mailgun.test_mode.should eql false
      end

      it "allows me to set my domain easily" do
        Mailgun.domain.should eql 'some-domain'
      end
    end
  end
end
