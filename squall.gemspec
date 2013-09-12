# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "squall/support/version"

Gem::Specification.new do |s|
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.name        = "squall"
  s.version     = Squall::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Justin Mazzi"]
  s.email       = ["jmazzi@site5.com"]
  s.homepage    = ""
  s.summary     = %q{A Ruby library for working with the OnApp REST API}
  s.description = %q{A Ruby library for working with the OnApp REST API}
  s.license     = 'MIT'

  s.rubyforge_project = "squall"

  s.add_runtime_dependency 'faraday', '~> 0.8.1'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.8.7'
  s.add_runtime_dependency 'json', '~> 1.7.3'
  s.add_runtime_dependency('jruby-openssl', '~> 0.7.3') if RUBY_PLATFORM == 'java'

  s.add_development_dependency 'rspec', '~> 2.10.0'
  s.add_development_dependency 'fakeweb', '~> 1.3'
  s.add_development_dependency 'vcr', '~> 1.8'
  s.add_development_dependency 'awesome_print', '~> 1.0.2'
  s.add_development_dependency 'rake', '~> 0.9.2.2'
  s.add_development_dependency 'rake-tomdoc', '~> 0.0.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
