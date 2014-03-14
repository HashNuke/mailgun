require 'uri'

module Mailgun
  class Event
    attr_accessor :items, :page
    
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    # list events
    def list(options={})
      @stored_options = options.dup
      @response = Mailgun.submit(:get, events_url(options[:address]), options)
      @items = @response["items"] || []
      @page = @response["paging"] || {}
      self
    end

    def next
      return unless next?
      @mailgun.events.list(@stored_options.merge(address: address(@page["next"])))
    end

    def next?
      @items.count > 0
    end

    #private

    def address(uri)
      URI.parse(uri).path.split("/").last if uri
    end

    # Helper method to generate the proper url for Mailgun event API calls
    def events_url(address=nil)
      "#{@mailgun.base_url}/#{@domain}/events#{'/' + address if address}"
    end
  end
end
