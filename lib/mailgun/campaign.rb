module Mailgun

  # Interface to manage campaigns
  class Campaign

    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @domain = domain
      @mailgun = mailgun
    end

    # List all domains on the account
    def list(options={})
      Mailgun.submit(:get, campaign_url, options)["items"] || []
    end

    # Find campaign by id
    def find(id)
      Mailgun.submit :get, campaign_url(id)
    end

    # Add campaign to account
    def create(name, id=nil)
      campaign_opts = {name: name}
      campaign_opts = campaign_opts.merge({id: id}) unless id.nil?
      Mailgun.submit(:post, campaign_url, campaign_opts)
    end

    # Update an existing campaign
    def update(campaign, opts)
      raise ArgumentError, "Missing options hash" unless opts.is_a?(Hash)
      campaign_opts = {}
      campaign_opts = campaign_opts.merge({:name => opts[:name]}) if opts.has_key?(:name)
      campaign_opts = campaign_opts.merge({:id => opts[:id]}) if opts.has_key?(:id)

      if campaign_opts.empty?
        raise ArgumentError, "Options hash has no ID/Name"
      end
      Mailgun.submit(:put, campaign_url(campaign), opts)
    end

    # Removes a campaign from account
    def delete(campaign)
      Mailgun.submit :delete, campaign_url(campaign)
    end


    private

    # Helper method to generate the proper url for Mailgun campaign API calls
    def campaign_url(id = nil)
      "#{@mailgun.base_url}/#{@domain}/campaigns#{'/' + id.to_s if id}"
    end

  end
end