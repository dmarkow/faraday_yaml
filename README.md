# Faraday YAML Middleware

Yeah, JSON is at least 2.9x cooler than YAML, but sometimes you're stuck using it, right?

## Installation

    gem install faraday_yaml

### Examples

Github's YAML API is currently deprecated; it works for the response example, but not for the request example.

#### Response

    conn = Faraday::Connection.new(:url => "http://github.com") do |builder|
      builder.adapter Faraday.default_adapter
      builder.use Faraday::Response::YAML
    end

    resp = conn.get do |req|
      req.url "/api/v2/yaml/user/show/dmarkow"
    end

    u = resp.body
    u['user']['name']
    # => "Dylan Markow"

#### Request

    conn = Faraday::Connection.new(:url => "http://USERNAME:PASSWORD@github.com") do |builder|
      builder.adapter Faraday.default_adapter
      builder.use Faraday::Request::YAML
      builder.use Faraday::Response::YAML
    end

    resp = conn.post do |req|
      req.url "/api/v2/yaml/user/show/dmarkow"
      req.body = {
        "values" => {
          "location" => "Portland, OR"
        }
      }
    end

    u = resp.body
    u['user']['location']
    # => "Portland, OR"
