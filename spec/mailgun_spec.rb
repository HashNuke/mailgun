require "spec_helper"

describe Mailgun do
  describe "configuration" do
    it "allows me to set my API key easily" do
      Mailgun.configure do |c|
        c.api_key = 'some-api-key'
      end
      Mailgun.api_key.should eql 'some-api-key'
    end
    it "allows me to set my domain easily" do
      Mailgun.configure do |c|
        c.domain = 'some-domain'
      end
      Mailgun.domain.should eql 'some-domain'
    end
  end
end
