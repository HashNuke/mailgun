require 'spec_helper'

describe Mailgun::Base do

	before :each do
		@mailgun = Mailgun({:api_key => "some-junk-string"})		# used to get the default values

		@sample_options = {
			:api_key 		 	=> @mailgun.api_key,
			:api_version 	=> @mailgun.api_version,
			:protocol 		=> @mailgun.protocol,
			:mailgun_host => @mailgun.mailgun_host
		}
  end

  describe "new" do
    it "Mailgun() method should return a new Mailgun object" do
      @mailgun.should be_kind_of(Mailgun::Base)
    end

    it "should use https by default" do
      @mailgun.protocol.should == "https"
    end
  end

	describe "base_url" do
		it "should return https url if use_https is true" do
			mailgun = Mailgun(@sample_options)
			mailgun.send(:base_url).should == "https://api:#{mailgun.api_key}@#{mailgun.mailgun_host}/#{mailgun.api_version}"
		end
	end
end
