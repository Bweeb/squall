begin
  require 'bundler/gem_tasks'
  require 'rspec/core/rake_task'
  require 'rake-tomdoc'
rescue LoadError
  abort "Please install rspec (bundle install)"
end

RSpec::Core::RakeTask.new :spec
Bundler::GemHelper.install_tasks

task :default => [:spec]
