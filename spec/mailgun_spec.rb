require "spec_helper"

describe Mailgun do

	before :each do
		@mailgun = Mailgun.new({:api_key => "some-junk-string"})		# used to get the default values
		@sample_options = {
			:api_key 		 	=> @mailgun.api_key,
			:api_version 	=> @mailgun.api_version,
			:use_https 		=> @mailgun.use_https,
			:mailgun_host => @mailgun.mailgun_host
		}
		@mailbox_options = { :name => "test", :domain => "sample.mailgun.com" }
	end

	describe "new" do
		it "Mailgun() method should return a new Mailgun object" do
			@mailgun.should be_kind_of(Mailgun)	
		end

		it "should use https by default" do
			@mailgun.use_https.should be_true
		end
	end

	describe "base_url" do
		it "should return https url if use_https is true" do
			mailgun = Mailgun(@sample_options)
			mailgun.base_url.should == "https://api:#{mailgun.api_key}@#{mailgun.mailgun_host}/#{mailgun.api_version}"
		end
	end

	describe "list_mailboxes" do
		it "should make a get request with the right params" do
			RestClient.should_receive(:get)
								.with("#{@mailgun.base_url}/#{@mailbox_options[:domain]}/mailboxes").and_return("{}")
			@mailgun.list_mailboxes :domain => @mailbox_options[:domain]
		end
	end

	describe "create mailbox" do
		it "should make a post request with the right params"	do
			RestClient.should_receive(:post)
								.with("#{@mailgun.base_url}/#{@mailbox_options[:domain]}/mailboxes",
											:mailbox  => @mailbox_options[:name]+"@"+@mailbox_options[:domain],
											:password => @mailbox_options[:password])
								.and_return({})

			@mailgun.create_mailbox :name => @mailbox_options[:name],
															:domain => @mailbox_options[:domain],
															:password => @mailbox_options[:password]
		end
	end

	describe "update mailbox password" do
		it "should make a put request with the right params" do
			RestClient.should_receive(:put)
								.with("#{@mailgun.base_url}/#{@mailbox_options[:domain]}/mailboxes/#{@mailbox_options[:name]}",
											:password => @mailbox_options[:password])
								.and_return({})

			@mailgun.update_mailbox_password :name => @mailbox_options[:name],
																			 :domain => @mailbox_options[:domain],
																			 :password => @mailbox_options[:password]
		end
	end

	describe "delete mailbox" do
		it "should make a put request with the right params" do
			RestClient.should_receive(:delete)
								.with("#{@mailgun.base_url}/#{@mailbox_options[:domain]}/mailboxes/#{@mailbox_options[:name]}")
								.and_return({})

			@mailgun.delete_mailbox :name => @mailbox_options[:name],
															:domain => @mailbox_options[:domain]
		end
	end

end