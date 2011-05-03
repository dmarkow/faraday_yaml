require File.expand_path('../../lib/faraday_yaml.rb', __FILE__)

class DummyApp
  attr_accessor :env

  def call(env)
    @env = env
  end

  def reset
    @env = nil
  end
end

