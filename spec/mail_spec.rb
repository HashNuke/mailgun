require 'spec_helper'

describe Mailgun::Mail do

  before :each do
    Mailgun.configure do |c|
        c.api_key = 'key'
        c.domain = 'domain'
      end

    @mailgun = Mailgun()
  end
    
  it "should raise an error if sender field has not been set" do
    
    expect do      
      @mailgun.message.send(:to => 'receiver@example.org')
    end.to raise_error ArgumentError
    
  end
  
  it "should raise an error if recipient field has not been set" do
    
    expect do      
      @mailgun.message.send(:from => 'sender@example.org')
    end.to raise_error ArgumentError
    
  end
  
  it "should make a POST request with correct params when sending email" do
  
    response_message = '{"message"=>"Queued. Thank you.", "id"=>"<201301234533151.6592.11249@app123456.mailgun.org>"}'
    Mailgun.should_receive(:submit)
      .with(:post, "#{@mailgun.base_url}/#{Mailgun.domain}/messages", instance_of(Multimap))
      .and_return(response_message)
    
    @mailgun.message.send(:from => 'sender@example.org', :to => 'receiver@example.org', :text => 'hi', :subject => 'test')
    
  end
    
end  
