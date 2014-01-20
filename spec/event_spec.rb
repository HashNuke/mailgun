require 'spec_helper'

describe Mailgun::Events do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})   # used to get the default values
  end

  describe "get events" do
    it "should make a GET request with the right params" do
      sample_response = <<EOF
 {
 "items": [
   {
      "campaigns":[

      ],
      "user-variables":{

      },
      "flags":{
         "is-test-mode":false
      },
      "tags":[

      ],
      "timestamp":1378335036.859382,
      "message":{
         "headers":{
            "to":"satshabad <satshabad@mailgun.com>",
            "message-id":"CAC8xyJxAO7Y0sr=3r-rJ4C6ULZs3cSVPPqYEXLHtarKOKaOCKw@mail.gmail.com",
            "from":"Someone <someone@example.com>",
            "subject":"Re: A TEST"
         },
         "attachments":[

         ],
         "recipients":[
            "satshabad@mailgun.com"
         ],
         "size":2566
      },
      "storage":{
         "url":"https://api.mailgun.net/v2/domains/ninomail.com/messages/WyI3MDhjODgwZTZlIiwgIjF6",
         "key":"WyI3MDhjODgwZTZlIiwgIjF6"
      },
      "event":"stored"
   }
 ]
}
EOF

      parameters = {
         :end   => "Wed, 15 Feb 2012 13:03:31 GMT",
         :event   => 'stored'
      }

      Mailgun.should_receive(:submit).
        with(:get, @mailgun.events.send('events_url'), parameters).
        and_return(sample_response)

      @mailgun.events.list parameters
    end
  end


end