require "spec_helper"

describe Mailgun::Route do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})		# used to get the default values
    @sample_route_id = "a45cd"
  end

  describe "list routes" do
    before :each do
      sample_response = "{\"items\": []}"
      RestClient.should_receive(:get)
        .with("#{@mailgun.routes.send(:route_url)}",:limit=>100, :skip=>0)
        .and_return(sample_response)
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
      RestClient.should_receive(:get)
        .with("#{@mailgun.routes.send(:route_url, @sample_route_id)}", {})
        .and_return("{\"route\": {\"id\": \"#{@sample_route_id}\" }}")
      @mailgun.routes.get @sample_route_id
    end
  end

  describe "create route" do
    it "should make a POST request with the right params" do
      options = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
      options[:description] = "test_route"
      options[:priority]   = 1
      options[:expression] = "match_recipent(\"sample.mailgun.org\")"
      options[:action]     = "forward(\"http://test-site.com\")"
      
      RestClient.should_receive(:post)
        .with("#{@mailgun.routes.send(:route_url)}", {
          :description => options[:description],
          :priority    => options[:priority],
          :expression  => options[:expression],
          :action      => options[:action]
        })
        .and_return("{\"route\": {\"id\": \"@sample_route_id\"}}")
      
      @mailgun.routes.create(
        options[:description],
        options[:priority],
        options[:expression],
        [options[:action]]
      )
    end
  end

  describe "update route" do
    it "should make a PUT request with the right params" do

      options = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
      options[:description] = "test_route"
      
      RestClient.should_receive(:put)
        .with("#{@mailgun.routes.send(:route_url, @sample_route_id)}", options)
        .and_return("{\"id\": \"#{@sample_route_id}\"}")
      @mailgun.routes.update @sample_route_id, options
    end
  end

  describe "delete route" do
    it "should make a DELETE request with the right params" do
      RestClient.should_receive(:delete)
        .with("#{@mailgun.routes.send(:route_url, @sample_route_id)}", {})
        .and_return("{\"id\": \"#{@sample_route_id}\"}")
      @mailgun.routes.destroy @sample_route_id
    end
  end
end
