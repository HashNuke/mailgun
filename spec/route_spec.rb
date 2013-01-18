require "spec_helper"

describe Mailgun::Route do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values
    @sample_route_id = "a45cd"
  end

  describe "list routes" do
    before :each do
      sample_response = <<EOF
{
  "total_count": 0,
  "items": []
}
EOF.to_json

      Mailgun.should_receive(:submit).
        with(:get, "#{@mailgun.routes.send(:route_url)}", {}).
        and_return(sample_response)
    end

    it "should make a GET request with the right params" do
      @mailgun.routes.list
    end

    it "should respond with an Array" do
      @mailgun.routes.list.should be_kind_of(Array)
    end
  end

  describe "get route" do
    it "should make a GET request with the right params" do
      sample_response = <<EOF
{
  "route": {
      "description": "Sample route",
      "created_at": "Wed, 15 Feb 2012 13:03:31 GMT",
      "actions": [
          "forward(\"http://myhost.com/messages/\")",
          "stop()"
      ],
      "priority": 1,
      "expression": "match_recipient(\".*@samples.mailgun.org\")",
      "id": "4f3bad2335335426750048c6"
  }
}
EOF

      Mailgun.should_receive(:submit).
        with(:get, "#{@mailgun.routes.send(:route_url, @sample_route_id)}").
        and_return(sample_response)

      @mailgun.routes.find @sample_route_id
    end
  end

  describe "create route" do
    it "should make a POST request with the right params" do
      options = {}

      options[:description] = "test_route"
      options[:priority]    = 1
      options[:expression]  = [:match_recipient, "sample.mailgun.org"]
      options[:action]      = [[:forward, "http://test-site.com"], [:stop]]

      Mailgun.should_receive(:submit)
        .with(:post, @mailgun.routes.send(:route_url), instance_of(Multimap))
        .and_return("{\"route\": {\"id\": \"@sample_route_id\"}}")
      
      @mailgun.routes.create(
        options[:description],
        options[:priority],
        options[:expression],
        options[:action],
      )
    end
  end

  describe "update route" do
    it "should make a PUT request with the right params" do
      options = {}
      options[:description] = "test_route"

      Mailgun.should_receive(:submit)
        .with(:put, "#{@mailgun.routes.send(:route_url, @sample_route_id)}", instance_of(Multimap))
        .and_return("{\"id\": \"#{@sample_route_id}\"}")
      @mailgun.routes.update @sample_route_id, options
    end
  end

  describe "delete route" do
    it "should make a DELETE request with the right params" do
      Mailgun.should_receive(:submit).
        with(:delete, "#{@mailgun.routes.send(:route_url, @sample_route_id)}").
        and_return("{\"id\": \"#{@sample_route_id}\"}")
      @mailgun.routes.destroy @sample_route_id
    end
  end
end
