require 'spec_helper'

describe Mailgun::Base do

  it "should raise an error if the api_key has not been set" do
    Mailgun.config { |c| c.api_key = nil }
    expect do
      Mailgun()
    end.to raise_error ArgumentError
  end

  it "can be called directly if the api_key has been set via Mailgun.configure" do
    Mailgun.config { |c| c.api_key = "some-junk-string" }
    expect do
      Mailgun()
    end.not_to raise_error()
  end

  it "can be instanced with the api_key as a param" do
    expect do
      Mailgun({api_key: "some-junk-string"})
    end.not_to raise_error()
  end

  describe "Mailgun.new" do
    it "Mailgun() method should return a new Mailgun object" do
      mailgun = Mailgun({api_key: "some-junk-string"})
      expect(mailgun).to be_kind_of(Mailgun::Base)
    end
  end

  describe "resources" do
    before :each do
      @mailgun = Mailgun({api_key: "some-junk-string"})
    end

    it "Mailgun#mailboxes should return an instance of Mailgun::Mailbox" do
      expect(@mailgun.mailboxes).to be_kind_of(Mailgun::Mailbox)
    end

    it "Mailgun#routes should return an instance of Mailgun::Route" do
      expect(@mailgun.routes).to be_kind_of(Mailgun::Route)
    end
  end

  describe "internal helper methods" do
    before :each do
      @mailgun = Mailgun({api_key: "some-junk-string"})
    end

    describe "Mailgun#base_url" do
      it "should return https url if use_https is true" do
      expect(@mailgun.base_url).to eq "https://api:#{Mailgun.api_key}@#{Mailgun.mailgun_host}/#{Mailgun.api_version}"
      end
    end

    describe "Mailgun.submit" do
      let(:client_double) { double(Mailgun::Client) }

      before do
        allow(Mailgun::Client).to receive(:new)
          .with('/')
          .and_return(client_double)
      end

      it "should send method and arguments to Mailgun::Client" do
        expect(client_double).to receive(:test_method)
          .with({arg1: "val1"})
          .and_return('{}')

        Mailgun.submit :test_method, '/', arg1: "val1"
      end

      context 'when the client throws an exception' do
        let(:exception) { Mailgun::ClientError.new(http_code: 404, http_body: "{\n  \"message\": \"Domain not found: superstore.com\"\n}") }

        before do
          allow(client_double).to receive(:test_method)
            .with({arg1: "val1"})
            .and_raise(exception)
        end

        it 'uses the error handler' do
          expect {
            Mailgun.submit :test_method, '/', arg1: "val1"
          }.to raise_error(Mailgun::NotFound)
        end
      end
    end
  end

  describe "configuration" do
    describe "default settings" do
      it "api_version is v3" do
        expect(Mailgun.api_version).to eql 'v3'
      end
      it "should use https by default" do
        expect(Mailgun.protocol).to eq "https"
      end
      it "mailgun_host is 'api.mailgun.net'" do
        expect(Mailgun.mailgun_host).to eql 'api.mailgun.net'
      end

      it "test_mode is false" do
        expect(Mailgun.test_mode).to eql false
      end

      it "domain is not set" do
        expect(Mailgun.domain).to be_nil
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

      after(:each) { Mailgun.configure { |c| c.domain = nil } }

      it "allows me to set my API key easily" do
        expect(Mailgun.api_key).to eql 'some-api-key'
      end

      it "allows me to set the api_version attribute" do
        expect(Mailgun.api_version).to eql 'v2'
      end

      it "allows me to set the protocol attribute" do
        expect(Mailgun.protocol).to eql 'https'
      end

      it "allows me to set the mailgun_host attribute" do
        expect(Mailgun.mailgun_host).to eql 'api.mailgun.net'
      end
      it "allows me to set the test_mode attribute" do
        expect(Mailgun.test_mode).to eql false
      end

      it "allows me to set my domain easily" do
        expect(Mailgun.domain).to eql 'some-domain'
      end
    end
  end
end
