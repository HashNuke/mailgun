module Mailgun

  # Interface to manage bounce lists
  # Refer - http://documentation.mailgun.net/api-bounces.html for optional params to pass
  class Event

    attr_accessor :items, :page, :domain, :mailgun, :action, :options

    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    # List all events for a given domain
    #
    # @param options [Hash] options to populate to mailgun find
    # @option options [Integer] limit     (100)   limit of results
    # @option options [Time]    begin     (nil)   date to begin
    # @option options [Time]    end       (nil)   date to end
    # @option options [String]  url       (nil)   url
    # @option options [Boolean] ascending (false) orgering of the records
    # @option options [Symbol]  event     (nil)   if present filter by event type
    # @option options [String]  list      (nil)   if present filter by email address of a mailing list the message was originally sent to
    # @option options [String]  attachment(nil)   if present filter by name of an attached file
    # @option options [String]  from      (nil)   if present filter by message id returned by the messages API
    # @option options [String]  subject   (nil)   if present filter by subject line
    # @option options [String]  to        (nil)   if present filter by email address mentioned in the to MIME header
    # @option options [String]  size      (nil)   if present filter by Message size. Mostly intended to be used with range filtering expressions (see below)
    # @option options [String]  recipient (nil)   if present filter by email address of a particular recipient
    # @option options [String]  tags      (nil)   if present filter by user defined tags
    #
    # * Filter Expression:
    #
    # /  Expression      / Description
    # //////////////////////////////////////////////////////////////////////////////////
    # /  foo bar         / Matches field values that contain both term foo and term bar.
    # /  foo             / AND bar Same as above.
    # /  foo OR bar      / Matches field values that contain either term foo or term bar.
    # /  “foo bar”       / Matches field values that literally contain foo bar.
    # /  foo -bar        / Matches field values that contain term foo but do not contain term bar.
    # /  >10000          / Matches values that greater then 10000. This filter can be applied to numeric fields only.
    # /  >10000 <20000   / Matches values that are greater then 10000 and less then 20000. This filter can be applied to numeric fields only.
    #
    # @returns [Array<Hash>] array of bouces
    def list(options={})
      @action = :list
      @options = check_options
      url = options[:url] || event_url
      @response = Mailgun.submit(:get, url, @options)
      @items = response["items"] || []
      @page = response["paging"] || {}
      self
    end

    # Returns a new Event object for the new page
    #
    # @return [Event]
    def next
      return unless next?
      Events.send(action, options.merge(url: page["next"]))
    end

    # Check if there is a next page
    #
    # @return [Boolean] false
    def next?
      page["next"].present?
    end

    # Returns a new Event object for the prev page
    #
    # @return [Event]
    def prev
      return unless prev?
      Event.send(action, options.merge(url: page["previous"]))
    end

    # Check if there is a prev page
    #
    # @return [Boolean] false
    def prev?
      page["previous"].present?
    end

    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def event_url(address=nil)
      "#{@mailgun.base_url}/#{@domain}/events#{'/' + address if address}"
    end

    # Validates filter query options and parses it to feet in the
    # mailgun api definition
    def check_options(options={})
      if options[:ascending]
        raise ArgumentError, 'Invalid type for ascending option, expected Boolean' unless options[:ascending].is_a? Boolean
        options[:ascending] = options[:ascending] ? 'yes' : 'no'
      end
      if options[:begin]
        raise ArgumentError, 'Invalid type for begin option, expected Time' unless options[:begin].is_a? Time
        options[:begin] = options[:begin].try(:to_s)
      end
      if options[:end]
        raise ArgumentError, 'Invalid type for end option, expected Time' unless options[:end].is_a? Time
        options[:end] = options[:end].try(:to_s)
      end
      if options[:event]
        allowed_event_types = [:accepted, :rejected, :delivered, :failed, :opened, :clicked, :unsubscribed, :complained, :stored]
        raise ArgumentError, 'Invalid type for end option, expected Time' unless options[:event].is_a? Symbol
        raise ArgumentError, 'Invalid event type for end option, accepted types are: #{allowed_event_types.join(', ')}' unless allowed_event_types.includes? options[:event]
        options[:event] = options[:event].to_s
      end
      options
    end

  end
end
