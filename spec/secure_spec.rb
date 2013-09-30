require 'spec_helper'

require './spec/helpers/mailgun_helper.rb'

RSpec.configure do |c|
  c.include MailgunHelper
end

describe Mailgun::Secure do

  before :each do
    @mailgun = Mailgun({:api_key => "some-api-key"})   # used to get the default values
  end
  
  it "generate_request_auth helper should generate a timestamp, a token and a signature" do
    timestamp, token, signature = generate_request_auth("some-api-key")
    
    timestamp.should_not    be_nil
    token.length.should     == 50
    signature.length.should == 64
  end

  it "check_request_auth should return true for a recently generated authentication" do
    timestamp, token, signature = generate_request_auth("some-api-key")
    
    result = @mailgun.secure.check_request_auth(timestamp, token, signature)
    
    result.should be_true
  end
  
  it "check_request_auth should return false for an authentication generated more than 5 minutes ago" do
    timestamp, token, signature = generate_request_auth("some-api-key", -6)
    
    result = @mailgun.secure.check_request_auth(timestamp, token, signature)
    
    result.should be_false
  end
  
  it "check_request_auth should return true for an authentication generated any time when the check offset is 0" do
    timestamp, token, signature = generate_request_auth("some-api-key", -6)
    
    result = @mailgun.secure.check_request_auth(timestamp, token, signature, 0)
    
    result.should be_true
  end
  
  it "check_request_auth should return false for a different api key, token or signature" do
    timestamp, token, signature = generate_request_auth("some-different-api-key")
    
    result = @mailgun.secure.check_request_auth(timestamp, token, signature)
    
    result.should be_false
  end

end