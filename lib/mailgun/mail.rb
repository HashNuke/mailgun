# Sends a mail message
#
# @author Jon Yom-Tov
#
# Usage:
#
module Mailgun
  class Mail
    
    SPECIAL_KEYS = [:at, :tags]
    
    # @note Do <b>not</b> use this constructor directly! See below for usage.
    # @example
    #   require 'mailgun'
    #
    #   Mailgun.configure do |c|
    #     c.api_key = 'key'
    #     c.domain = 'domain'
    #   end
    #
    #   mailgun = Mailgun()
    #   mailgun.message.send(:from => 'recipient@example.org', :to => 'sender@example.org', :text => 'hi', :subject => 'test') 
    # @param mailgun [Mailgun] an instance of Mailgun
    # @param domain [String] the domain given to you by Mailgun
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain = domain
    end
    
    # Sends an email
    # @note All values in the <tt>options</tt> hash can be either scalars or arrays. <tt>:attachment</tt> must be a file handle, all others are strings. 
    # @param options [Hash] is a hash with mandatory keys <tt>:from</tt> and <tt>:to</tt> or <tt>:cc</tt> or <tt>:bcc</tt>, 
    #   and optional keys <tt>:subject</tt>, <tt>:text</tt>, <tt>:html</tt>, <tt>:attachment</tt>.
    #   Special key <tt>:at</tt> can be a Time object or time string specifying when to send the message, special key <tt>:tags</tt> is an array of tags specifying tags for the message.
    # @raise [ArgumentError] if sender and at least one recipient is not specified 
    # @return [String] the message from Mailgun
    def send(options)
      raise ArgumentError.new('Message must have a sender and at least one recipient') if !options.has_key?(:from) || !(options.has_key?(:to) || options.has_key?(:cc) || options.has_key?(:bcc))
      
      data = options.reject{|key| SPECIAL_KEYS.include?(key) }.inject(::Multimap.new) do |map, kvp|
        if kvp[1].is_a?(Array)
         kvp[1].each{|value| map[kvp[0]] = value }
        else
          map[kvp[0]] = kvp[1]
        end 
        map
      end

      if options.has_key?(:at)
        data['o:deliverytime'] = options[:at].to_s
      end  
      
      if options.has_key?(:tags)
        options[:tags].each{|tag| data['o:tag'] = tag }
      end 
      
      if Mailgun.test_mode
        data['o:testmode'] = true
      end
      
      Mailgun.submit(:post, mail_url, data)   
    end
    
    private
    
    # @private
    def mail_url
      "#{@mailgun.base_url}/#{@domain}/messages"
    end
    
  end
end
