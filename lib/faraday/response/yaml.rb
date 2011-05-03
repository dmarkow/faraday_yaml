require 'faraday'

module Faraday
  class Response::YAML < Response::Middleware
    dependency 'yaml'

    def parse(body)
      case body
      when ''
        nil
      else
        YAML.load(body)
      end
    rescue Object => err
      raise Faraday::Error::ParsingError.new(err)
    end
  end
end
