require 'bundler'
require 'uri'
require 'rake-tomdoc'
begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts "Please install rspec (bundle install)"
  exit
end

RSpec::Core::RakeTask.new :spec
Bundler::GemHelper.install_tasks

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/squall.rb -I ./lib"
end

task :default => [:spec]
