require 'faraday'

class Faraday::Request
  autoload :YAML, 'faraday/request/yaml.rb'
end

class Faraday::Response
  autoload :YAML, 'faraday/response/yaml.rb'
end
