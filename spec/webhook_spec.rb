require 'spec_helper'

describe Mailgun::Webhook do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key", :webhook_url => "http://postbin.heroku.com/860bcd65"})

    @sample = {
      :id     => "click",
      :url    => "http://postbin.heroku.com/860bcd65"
    }
  end

  describe "list avabilable webhook ids" do
    it "should return the correct ids" do
      expect(@mailgun.webhooks.available_ids).to match_array %i(bounce deliver drop spam unsubscribe click open)
    end
  end

  describe "list webhooks" do
    it "should make a GET request with the correct params" do

      sample_response = "{\"total_count\": 1, \"items\": [{\"webhooks\":{\"open\":{\"url\":\"http://postbin.heroku.com/860bcd65\"},\"click\":{\"url\":\"http://postbin.heroku.com/860bcd65\"}}}]}"
      webhooks_url = @mailgun.webhooks.send(:webhook_url)

      expect(Mailgun).to receive(:submit).
        with(:get, webhooks_url).
        and_return(sample_response)

      @mailgun.webhooks.list
    end
  end

  describe "find a webhook" do
    it "should make a GET request with correct params to find a given webhook" do
      sample_response = "{\"webhook\": {\"url\":\"http://postbin.heroku.com/860bcd65\"}"
      webhooks_url = @mailgun.webhooks.send(:webhook_url, @sample[:id])

      expect(Mailgun).to receive(:submit).
        with(:get, webhooks_url).
        and_return(sample_response)

      @mailgun.webhooks.find(@sample[:id])
    end
  end

  describe "add a webhook" do
    context "using the default webhook url" do
      it "should make a POST request with correct params to add a webhook" do
        sample_response = "{\"message\":\"Webhook has been created\",\"webhook\":{\"url\":\"http://postbin.heroku.com/860bcd65\"}}"
        webhooks_url = @mailgun.webhooks.send(:webhook_url)

        expect(Mailgun).to receive(:submit).
          with(:post, webhooks_url, {:id => @sample[:id], :url => @sample[:url]}).
          and_return(sample_response)

        @mailgun.webhooks.create(@sample[:id])
      end
    end
    context "overwriting the default webhook url" do
      it "should make a POST request with correct params to add a webhook" do
        sample_response = "{\"message\":\"Webhook has been created\",\"webhook\":{\"url\":\"http://postbin.heroku.com/860bcd65\"}}"
        webhooks_url = @mailgun.webhooks.send(:webhook_url)
        overwritten_url = 'http://mailgun.net/webhook'

        expect(Mailgun).to receive(:submit).
          with(:post, webhooks_url, {:id => @sample[:id], :url => overwritten_url}).
          and_return(sample_response)

        @mailgun.webhooks.create(@sample[:id], overwritten_url)
      end
    end
  end

  describe "update a webhook" do
    context "using the default webhook url" do
      it "should make a POST request with correct params to add a webhook" do
        sample_response = "{\"message\":\"Webhook has been updated\",\"webhook\":{\"url\":\"http://postbin.heroku.com/860bcd65\"}}"
        webhooks_url = @mailgun.webhooks.send(:webhook_url, @sample[:id])

        expect(Mailgun).to receive(:submit).
          with(:put, webhooks_url, {:url => @sample[:url]}).
          and_return(sample_response)

        @mailgun.webhooks.update(@sample[:id])
      end
    end
    context "overwriting the default webhook url" do
      it "should make a POST request with correct params to add a webhook" do
        sample_response = "{\"message\":\"Webhook has been updated\",\"webhook\":{\"url\":\"http://postbin.heroku.com/860bcd65\"}}"
        webhooks_url = @mailgun.webhooks.send(:webhook_url, @sample[:id])
        overwritten_url = 'http://mailgun.net/webhook'

        expect(Mailgun).to receive(:submit).
          with(:put, webhooks_url, {:url => overwritten_url}).
          and_return(sample_response)

        @mailgun.webhooks.update(@sample[:id], overwritten_url)
      end
    end
  end

  describe "delete a webhook" do
    it "should make a DELETE request with correct params" do
      sample_response = "{\"message\":\"Webhook has been deleted\",\"webhook\":{\"url\":\"http://postbin.heroku.com/860bcd65\"}}"
      webhooks_url = @mailgun.webhooks.send(:webhook_url, @sample[:id])

      expect(Mailgun).to receive(:submit).
        with(:delete, webhooks_url).
        and_return(sample_response)

      @mailgun.webhooks.delete(@sample[:id])
    end
  end
end
