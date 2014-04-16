module Mailgun

  # Interface to manage stat lists
  # Refer - http://documentation.mailgun.net/api-stats.html for optional params to pass
  class Stat
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    # List all stats for a given domain
    #
    # @param options [Hash] options to populate to mailgun find
    # @option options limit (100) [Integer] limit of results
    # @option options skip  (0)   [Integer] number of results to skip
    # @option options event ('')  [String] name of the event
    # @option options start-date  [Date] date to receive the stats starting from
    #
    # @returns [Array<Hash>] array of stats
    def list(options={})
      Mailgun.submit(:get, stat_url, options) || []
    end

    private

    # Helper method to generate the proper url for Mailgun mailbox API calls
    def stat_url(otpions=nil)
      "#{@mailgun.base_url}/#{@domain}/stats"
    end

  end
end
