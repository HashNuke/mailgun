module Mailgun

  # Interface to manage campaigns
  class Campaign

    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain = domain
    end

    # List all campaigns on the account
    def list(options={})
      Mailgun.submit(:get, campaign_url, options)["items"] || []
    end

    # Find campaign by name
    def find(campaign)
      Mailgun.submit :get, campaign_url(campaign)
    end

    # Add campaign to account
    def create(campaign, opts = {})
      opts = {name: campaign}.merge(opts)
      Mailgun.submit :post, campaign_url, opts
    end

    # Remves a campaign from account
    def delete(campaign)
      Mailgun.submit :delete, campaign_url(campaign)
    end

    private

    # Helper method to generate the proper url for Mailgun campaign API calls
    def campaign_url(campaign = nil)
      "#{@mailgun.base_url}/#{@domain}/campaigns#{'/' + campaign if campaign}"
    end

  end
end
