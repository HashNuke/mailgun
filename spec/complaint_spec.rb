require 'spec_helper'

describe Mailgun::Complaint do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})

    @sample = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list complaints" do
    it "should make a GET request with the right params" do
      sample_response = <<EOF
{
  "total_count": 1,
  "items": [
      {
          "count": 2,
          "created_at": "Tue, 15 Nov 2011 08:25:11 GMT",
          "address": "romanto@profista.com"
      }
  ]
}
EOF

      complaints_url = @mailgun.complaints(@sample[:domain]).send(:complaint_url)

      Mailgun.should_receive(:submit).
        with(:get, complaints_url, {}).
        and_return(sample_response)

      @mailgun.complaints(@sample[:domain]).list
    end
  end


  describe "add complaint" do
    it "should make a POST request with correct params to add a given email address to complaint from a tag" do
      sample_response = <<EOF
{
  "message": "Address has been added to the complaints table",
  "address": "#{@sample[:email]}"
}
EOF

      complaints_url = @mailgun.complaints(@sample[:domain]).send(:complaint_url)

      Mailgun.should_receive(:submit)
        .with(:post, complaints_url, {:address => @sample[:email]})
        .and_return(sample_response)

      @mailgun.complaints(@sample[:domain]).add(@sample[:email])
    end
  end


  describe "find complaint" do
    it "should make a GET request with the right params to find given email address" do
      sample_response = <<EOF
{
  "complaint": {
      "count": 2,
      "created_at": "Tue, 15 Nov 2011 08:25:11 GMT",
      "address": "romanto@profista.com"
  }
}
EOF

      complaints_url = @mailgun.complaints(@sample[:domain]).send(:complaint_url, @sample[:email])

      Mailgun.should_receive(:submit)
        .with(:get, complaints_url)
        .and_return(sample_response)

      @mailgun.complaints(@sample[:domain]).find(@sample[:email])
    end
  end


  describe "delete complaint" do
    it "should make a DELETE request with correct params to remove a given email address" do
      sample_response = <<EOF
{
    "message": "Complaint event has been removed",
    "address": "#{@sample[:email]}"}"
}
EOF

      complaints_url = @mailgun.complaints(@sample[:domain]).send(:complaint_url, @sample[:email])

      Mailgun.should_receive(:submit)
        .with(:delete, complaints_url)
        .and_return(sample_response)

      @mailgun.complaints(@sample[:domain]).destroy(@sample[:email])
    end
  end

end
