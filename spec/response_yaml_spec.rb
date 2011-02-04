require 'spec_helper'

describe "Using the YAML Response Middleware" do

  before do
    @stubs = Faraday::Adapter::Test::Stubs.new
    @conn = Faraday::Connection.new do |conn|
      conn.adapter :test, @stubs
      conn.use Faraday::Response::YAML
    end
  end

  context "with a valid YAML response" do
    before do
      @stubs.get("/me") {[200, {'Content-Type' => 'application/x-yaml'}, "---\nuser:\n  name: Dylan Markow\n  username: dmarkow"]}
    end

    it "parses the response into a Hash" do
      me = @conn.get("/me").body['user']
      me.should be_a(Hash)
      me['name'].should == "Dylan Markow"
      me['username'].should == "dmarkow"
    end
  end

  context "with a nil response" do
    before do
      @stubs.get("/me") {[200, {'Content-Type' => 'application/x-yaml'}, nil]}
      @response = @conn.get("/me")
    end

    it "still uses the status code" do
      @response.status.should == 200
    end
    it "should skip empty content" do
      @response.body.should be_nil
    end
  end

  context "with an empty response" do
    before do
      @stubs.get("/me") {[200, {'Content-Type' => 'application/x-yaml'}, ""]}
      @response = @conn.get("/me")
    end

    it "still uses the status code" do
      @response.status.should == 200
    end

    it "should skip empty content" do
      @response.body.should be_nil
    end
  end
end
