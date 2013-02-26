require 'spec_helper'

describe Mailgun::Log do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})   # used to get the default values

    @sample = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "send email" do
    it "should make a POST request to send an email" do

      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      Mailgun.should_receive(:submit)
      .with(:get, "#{@mailgun.lists.send(:list_url, @sample[:list_email])}")
      .and_return(sample_response)

      @mailgun.lists.find(@sample[:list_email])

      sample_response = "{\"message\": \"Queued. Thank you.\",\"id\": \"<20111114174239.25659.5817@samples.mailgun.org>\"}"
      parameters = {
        :to => "cooldev@your.mailgun.domain",
        :subject => "missing tps reports",
        :text => "yeah, we're gonna need you to come in on friday...yeah.",
        :from => "lumberg.bill@initech.mailgun.domain"
      }
      Mailgun.should_receive(:submit)                            \
        .with(:post, @mailgun.messages.messages_url, parameters) \
        .and_return(sample_response)

      @mailgun.messages.send_email(parameters)
    end
  end

end