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
      Mailgun.submit(:post, publish_messages_url, parameters)
    end
    
    def find(address, parameters={})
      response = Mailgun.submit(:get, messages_url(address), parameters)
    end

    # Removes a stored message from account
    def delete(message_id)
      Mailgun.submit :delete, messages_url(message_id)
    end

    # Helper method to generate the proper url for Mailgun message API calls
    def publish_messages_url(address=nil)
      "#{@mailgun.base_url}/#{@domain}/messages"
    end

    def messages_url(address=nil)
      "#{@mailgun.base_url}/domains/#{@domain}/messages#{'/' + address if address}"
    end
  end
end
