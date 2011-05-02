require 'faraday'

module Faraday
  class Request::YAML < Faraday::Middleware
    begin
      require 'yaml'
    rescue LoadError, NameError => e
      self.load_error = e
    end

    def call(env)
      # Only set the request's Content-Type when actually needed. (Some APIs
      # break when you send a Content-Type header and an empty body on GET 
      # requests.)
      if [:put, :post].include?(env[:method])
        env[:request_headers]['Content-Type'] = 'application/x-yaml'
      end

      if env[:body] && !env[:body].respond_to?(:to_str)
        env[:body] = env[:body].to_yaml
      end
      @app.call env
    end
  end
end

