# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "faraday_yaml/version"

Gem::Specification.new do |s|
  s.name        = "faraday_yaml"
  s.version     = FaradayYaml::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dylan Markow"]
  s.email       = ["dylan@dylanmarkow.com"]
  s.homepage    = "http://github.com/dmarkow/faraday_yaml"
  s.summary     = %q{YAML Response/Request Middleware for Faraday}
  s.description = s.summary

  s.rubyforge_project = "faraday_yaml"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec", "~> 2.4.0"
  s.add_runtime_dependency "faraday", "~> 0.5.4"
end
