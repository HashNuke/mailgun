module Mailgun
  class Message
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    # send email
    def send_email(parameters={})
      # options:
      # :from, :to, :cc, :bcc, :subject, :text, :html
      # :with_attachment
      # :with_attachments
      # :at for delayed delivery time option
      # :in_test_mode BOOL. override the @use_test_mode setting
      # :tags to add tags to the email
      # :track BOOL
      Mailgun.submit(:post, messages_url, parameters)
    end

    #private

    # Helper method to generate the proper url for Mailgun message API calls
    def messages_url
      "#{@mailgun.base_url}/#{@domain}/messages"
    end
  end
end
