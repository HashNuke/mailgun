require "rest-client"

class Mailgun

  attr_accessor :api_key,
                :api_version,
                :use_https,
                :mailgun_host,
                :mailbox_domain,
                :use_test_mode


	def initialize(options)
		@api_key = options.fetch(:api_key) { nil }
    @api_version = options.fetch(:api_version) { "v2" }
    @use_https = options.fetch(:use_https) { true }
    @mailgun_host = options.fetch(:mailgun_host) {"api.mailgun.net"}
    @api_key =  options.fetch(:api_key) { nil }
    @mailbox_domain = options.fetch(:mailbox_domain) { nil }
    @test_mode = options.fetch(:test_mode) { false }
	end

  # send email
  def send_email()
    # TODO with the following options
    # :from, :to, :cc, :bcc, :subject, :text, :html 
    # :with_attachment
    # :with_attachments
    # :at for delayed delivery time option
    # :in_test_mode BOOL. override the @use_test_mode setting
    # :tags to add tags to the email
    # :track BOOL
  end


  # Mailboxes
  def list_mailboxes(domain)
    api_url = "#{base_url}/#{domain}/mailboxes"
    puts api_url
    api_call = RestClient.get api_url
  end
  
  def create_mailbox(options)
    mailbox_name = options.fetch(:name) { raise ArgumentError }
    password = options.fetch(:password) { raise ArgumentError }
    domain = options.fetch(:domain) { raise ArgumentError }
    full_mailbox_name = "#{name}@#{domain}"
    api_call = RestClient.post "#{Mailgun.base_url}/#{domain}/mailboxes", :mailbox => full_mailbox_name, :password => password
  end

  def update_mailbox_password(options)
    mailbox_name = options.fetch(:name) {raise ArgumentError }
    domain = options.fetch(:domain) {raise ArgumentError }
    password = options.fetch(:password) {raise ArgumentError }

    api_call = RestClient.put "#{Mailgun.base_url}/#{domain}/mailboxes/#{mailbox_name}", :password => password
  end

  def delete_mailbox(options)
    mailbox_name = options.fetch(:name) {raise ArgumentError }
    domain = options.fetch(:domain) {raise ArgumentError }

    api_call = RestClient.delete "#{Mailgun.base_url}/#{domain}/mailboxes/#{mailbox_name}"
  end

  def base_url
    if @use_https
      "https://api:#{api_key}@#{mailgun_host}/#{api_version}"
    else
      "http://api:#{api_key}@#{mailgun_host}/#{api_version}"
    end
  end

end
