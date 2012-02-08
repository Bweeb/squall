# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "squall/version"

Gem::Specification.new do |s|
  s.name        = "squall"
  s.version     = Squall::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Justin Mazzi"]
  s.email       = ["jmazzi@site5.com"]
  s.homepage    = ""
  s.summary     = %q{A Ruby library for working with the OnApp REST API}
  s.description = %q{A Ruby library for working with the OnApp REST API}

  s.rubyforge_project = "squall"

  s.add_runtime_dependency 'httparty', '~> 0.8.1'
  s.add_runtime_dependency('jruby-openssl', '~> 0.7.3') if RUBY_PLATFORM == 'java'

  s.add_development_dependency 'rspec', '~> 2.5'
  s.add_development_dependency 'fakeweb', '~> 1.3'
  s.add_development_dependency 'vcr', '~> 1.8'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'rake', '~> 0.8.7'
  if !defined?(RUBY_ENGINE) || RUBY_ENGINE != 'rbx'
    s.add_development_dependency 'rcov', '~> 0.9' 
    s.add_development_dependency 'metric_fu', '~> 2.1'
  end

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
