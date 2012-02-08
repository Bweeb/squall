require 'bundler'
require 'uri'
begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts "Please install rspec (bundle install)"
  exit
end

begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.rcov[:rcov_opts] << "-Ispec"
  end
rescue LoadError
end

RSpec::Core::RakeTask.new :spec
Bundler::GemHelper.install_tasks

desc  "Run all specs with rcov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/squall.rb -I ./lib"
end

task :default => [:spec]
