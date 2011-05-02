require 'spec_helper'

describe Faraday::Response::YAML do

  context "when used" do
    let(:yaml) { Faraday::Response::YAML.new }

    it "handles an empty response" do
      empty = yaml.on_complete(:body => '')
      empty.should be_nil
    end

    it "handles hashes" do
      me = yaml.on_complete(:body => "--- \nuser:\n  name: Dylan Markow\n  username: dmarkow\n")
      me.class.should == Hash
      me['user']['name'].should == 'Dylan Markow'
      me['user']['username'].should == 'dmarkow'
    end

    it "handles arrays" do
      values = yaml.on_complete(:body => "--- \n- 123\n- 456\n")
      values.class.should == Array
      values.first.should == 123
      values.last.should == 456
    end

    it "handles arrays of hashes" do
      values = yaml.on_complete(:body => "--- \n- user:\n    name: Dylan Markow\n    username: dmarkow\n- user:\n    name: Rick Olson\n    username: technoweenie\n")
      values.class.should == Array
      values.first['user']['username'].should == 'dmarkow'
      values.last['user']['username'].should == 'technoweenie'
    end

    it "handles mixed arrays" do
      values = yaml.on_complete(:body => "--- \n- 123\n- user: \n    name: Dylan Markow\n    username: dmarkow\n- 456\n")
      values.class.should == Array
      values.first.should == 123
      values.last.should == 456
      values[1]['user']['username'].should == 'dmarkow'
    end
  end

  context "integration tests" do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:conn) do
      Faraday.new do |conn|
        conn.adapter :test, stubs
        conn.use Faraday::Response::YAML
      end
    end

    it "creates a hash from the body" do
      stubs.get("/me") {[200, {'Content-Type' => 'application/x-yaml'}, "---\nuser:\n  name: Dylan Markow\n  username: dmarkow"]}
      me = conn.get("/me").body
      me.class.should == Hash
      me['user']['name'].should == "Dylan Markow"
      me['user']['username'].should == "dmarkow"
    end
  end
end

