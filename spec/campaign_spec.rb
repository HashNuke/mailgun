require 'spec_helper'

describe Mailgun::Campaign do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})   # used to get the default values

    @sample_capaign = {
      :id => "1",
      :name => "Test Campaign 1"
    }
    @sample = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "add campaign" do
    it "should make a POST response with the right params" do
      sample_response = "{\"name\": \"Test Campaign 1\", \"id\": \"1\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url)

      Mailgun.should_receive(:submit).with(:post, campaigns_url, {:name => @sample_capaign[:name], :id => @sample_capaign[:id]}).and_return(sample_response)
      @mailgun.campaigns.create(@sample_capaign[:name], @sample_capaign[:id])
    end
  end

  describe "list campaigns" do
    it "should make a GET request with the right params" do
      sample_response = "{\"total_count:\" 1, \"items:\" [{\"created_at\": \"Tue, 13 Feb 2013 21:11:51 GMT\", \"name\": \"Super Campaign\", \"id\": \"Custom ID\"}]}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url)

      Mailgun.should_receive(:submit).with(:get, campaigns_url, {}).and_return(sample_response)
      @mailgun.campaigns.list
    end

  end

  describe "find campaign" do
    it "should make a GET request with the right params" do
      sample_response = "{\"name\": \"Test Campaign 1\", \"id\": \"1\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url, "1")

      Mailgun.should_receive(:submit).with(:get, campaigns_url).and_return(sample_response)
      @mailgun.campaigns.find(1)
    end
  end

  describe "update campaign" do
    it "should make a PUT request with the right params" do
      sample_response = "{\"name\": \"Test Campaign 1\", \"id\": \"1\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url)

      Mailgun.should_receive(:submit).with(:post, campaigns_url, {:name => @sample_capaign[:name], :id => @sample_capaign[:id]}).and_return(sample_response)
      @mailgun.campaigns.create(@sample_capaign[:name], @sample_capaign[:id])

      sample_response = "{\"name\": \"Super Campaign 1\", \"id\": \"1\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url, "1")

      Mailgun.should_receive(:submit).with(:put, campaigns_url, {:name => "Super Campaign 1"})
      @mailgun.campaigns.update("1", {:name => "Super Campaign 1"})
    end

  end

  describe "delete campaign" do
    it "should make a DELETE request with the right params" do
      sample_response = "{\"message\": \"Campaign has been deleted\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url, @sample_capaign[:id])

      Mailgun.should_receive(:submit).with(:delete, campaigns_url).and_return(sample_response)
      @mailgun.campaigns.delete(@sample_capaign[:id])
    end
  end

end
