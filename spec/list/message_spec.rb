require 'spec_helper'

describe Mailgun::Message do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})   # used to get the default values

    @sample = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }

    @sample_message_key = "WyI3MDhjODgwZTZlIiwgIjF6"
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
        .with(:post, @mailgun.messages.send('send_messages_url'), parameters) \
        .and_return(sample_response)

      @mailgun.messages.send_email(parameters)
    end
  end

  describe "get email" do
    it "should make a GET request with the right params" do
      sample_response = <<EOF
{
   "headers"=>{
      "to"=>"lumberg.bill@initech.mailgun.domain",
      "message-id"=>"20111114174239.25659.5817@samples.mailgun.org",
      "from"=>"cooldev@your.mailgun.domain",
      "subject"=>"RE: missing tps reports"
   }
}
EOF

      Mailgun.should_receive(:submit).
        with(:get, @mailgun.messages.send('fetch_messages_url')+'/'+@sample_message_key).
        and_return(sample_response)

      @mailgun.messages.fetch_email @sample_message_key
    end
  end

  describe "delete email" do
    it "should make a DELETE request with the right params" do

      Mailgun.should_receive(:submit).
        with(:delete, @mailgun.messages.send('fetch_messages_url')+'/'+@sample_message_key).
        and_return({})

      @mailgun.messages.delete_email @sample_message_key
    end
  end

end