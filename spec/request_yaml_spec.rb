require 'spec_helper'

describe Faraday::Request::YAML do
  let(:test_hash) do
    {"user" => {"name" => "Dylan Markow", "username" => "dmarkow"}}
  end

  let(:test_yaml_string) { "--- \nuser: \n  name: Dylan Markow\n  username: dmarkow\n" }

  context "when used" do
    let(:yaml) { Faraday::Request::YAML.new(DummyApp.new) }
    let(:env) do
      {
        :request_headers => {},
        :method => :post,
        :body => test_hash,
        :url => Addressable::URI.parse("http://www.github.com")
      }
    end

    it "converts the body hash to yaml" do
      request = yaml.call(env)
      request[:body].should == test_yaml_string
    end

    it "sets the Content-Type header to x-yaml on put and post requests" do
      request = yaml.call(env)
      request[:request_headers]['Content-Type'].should == 'application/x-yaml'
    end

    it "doesn't set the Content-Type header on get requests" do
      env[:method] = :get
      request = yaml.call(env)
      request[:request_headers]['Content-Type'].should be_nil
    end
  end

  context "integration tests" do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:conn) do
      Faraday.new do |conn|
        conn.adapter :test, stubs
        conn.use Faraday::Request::YAML
      end
    end

    it "converts the body hash to yaml" do
      stubs.post('/echo') do |env|
        posted_as = env[:request_headers]['Content-Type']
        [200, {'Content-Type' => posted_as}, env[:body]]
      end
      response = conn.post('/echo', test_hash, 'Content-Type' => 'application/x-yaml')
      response.headers['Content-Type'].should == 'application/x-yaml'
      response.body.should == test_yaml_string
    end
  end
end
