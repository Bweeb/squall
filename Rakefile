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

desc "Sanitize sensitive info from cassettes"
task :sanitize_cassettes do
  yaml = File.join(ENV['HOME'], '.squall.yml')
  if File.exists?(yaml)
  	config = YAML::load_file(yaml)
    uri  = URI.parse(config['base_uri']).host
    user = config['username']
    pass = config['password']

    path = File.join(File.dirname(__FILE__), 'spec', 'vcr_cassettes')
    files = Dir.glob("#{path}/**/*.yml")
    if files.any?
      files.each do |file|
        old = File.read(file)
        # if old.match(/#{uri}|#{user}|#{pass}/)
          puts "Sanitizing #{file}"
          old.gsub!(user, 'user')
          old.gsub!(pass, 'pass')
          old.gsub!("https://#{uri}:443", 'http://www.example.com:80')
          old.gsub!(/_onapp_session=(.*?);/, "_onapp_session=WHAT;")
          old.gsub!(/- Basic .*/, "- Basic WHAT")
          File.open(file, 'w') do |f| 
            f.write old 
          end 
        # end 
      end 
    else
      puts "Nothing to sanitize"
    end 
  else
    puts "I can't sanitize without setting up WHM_HASH and WHM_HOST"
  end 
end

desc  "Run all specs with rcov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
end
