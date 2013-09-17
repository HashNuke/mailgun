require 'spec_helper'

describe Mailgun::Event do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @sample = {
      :email      => "test@sample.mailgun.org",
      :list_email => "dev@samples.mailgun.org",
      :name       => "test",
      :domain     => "sample.mailgun.org"
    }
  end

  describe "list events" do
    it "should make a GET request with the right params" do
      Mailgun.should_receive(:submit)
      .with(:get, "#{@mailgun.events.send(:events_url)}", {:"event"=>'stored'}).and_return("dummy response")
    
      @mailgun.events.list(:"event"=>'stored')
    end
  end
end