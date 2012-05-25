require 'spec_helper'

describe Mailgun::Complaint do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values

    @complaint_options = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list complaints" do
    it "should make a GET request with the right params" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get).with("#{@mailgun.complaints.send(:complaint_url, @complaint_options[:domain])}", {}).and_return(sample_response)

      @mailgun.complaints.list @complaint_options[:domain]
    end
  end

  describe "find complaint" do
    it "should make a GET request with the right params to find given email address" do
      sample_response = "{\"items\": [{\"size_bytes\": 0,  \"mailbox\": \"postmaster@bsample.mailgun.org\" }  ]}"
      RestClient.should_receive(:get)
      .with("#{@mailgun.complaints.send(:complaint_url, @complaint_options[:domain], @complaint_options[:email])}", {})
      .and_return(sample_response)

      @mailgun.complaints.find(@complaint_options[:domain], @complaint_options[:email])
    end
  end

  describe "delete complaint" do
    it "should make a DELETE request with correct params to remove a given email address" do
      response_message = "{\"message\"=>\"Complaint event has been removed\", \"address\"=>\"#{@complaint_options[:email]}\"}"
      Mailgun.should_receive(:submit)
      .with(:delete, "#{@mailgun.complaints.send(:complaint_url, @complaint_options[:domain], @complaint_options[:email])}")
      .and_return(response_message)

      @mailgun.complaints.remove(@complaint_options[:domain], @complaint_options[:email])
    end
  end

  describe "add complaint" do
    it "should make a POST request with correct params to add a given email address to complaint from a tag" do
      response_message = "{\"message\"=>\"Address has been added to the complaints table\", \"address\"=>\"#{@complaint_options[:email]}\"}"
      Mailgun.should_receive(:submit)
      .with(:post, "#{@mailgun.complaints.send(:complaint_url, @complaint_options[:domain])}",{:address=>@complaint_options[:email]})
      .and_return(response_message)
      @mailgun.complaints.add(@complaint_options[:domain],@complaint_options[:email])
    end
  end

end
