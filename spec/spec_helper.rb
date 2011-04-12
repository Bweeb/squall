require 'yaml'
require 'rspec'
require 'vcr'
require 'squall'

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb
  c.default_cassette_options = {:record => :new_episodes}
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.after(:each) do
    Squall.reset_config
  end
end

def default_config
  yaml = File.join(ENV['HOME'], '.squall.yml')
  if ENV['SQUALL_LIVE'] && File.exists?(yaml)
    config = YAML::load_file(yaml)
    uri  = config['base_uri']
    user = config['username']
    pass = config['password']
  else
    uri  = 'http://www.example.com'
    user = 'user'
    pass = 'pass'
  end
  Squall.config do |c|
    c.base_uri uri
    c.username user
    c.password pass
  end
end

def requires_attr(attr, &block)
  expect { block.call }.to raise_error(ArgumentError, /Missing required params: #{attr}/i)
end