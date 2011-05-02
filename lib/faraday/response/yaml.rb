require 'faraday'

module Faraday
  class Response::YAML < Response::Middleware
    begin
      require 'yaml'
    rescue LoadError, NameError => e
      self.load_error = e
    end

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
