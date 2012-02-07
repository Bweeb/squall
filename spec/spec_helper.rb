require 'yaml'
require 'rspec'
require 'vcr'
require 'squall'

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb
  c.default_cassette_options = {:record => :new_episodes}
  c.filter_sensitive_data("Basic <REDACTED>") { |i| [i.request.headers['authorization']].flatten.first }
  c.filter_sensitive_data("<REDACTED>") { |i| [i.response.headers['set-cookie']].flatten.first }
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
    VCR.config do |c|
      c.filter_sensitive_data("www.example.com") { URI.parse(config['base_uri']).host }
      c.filter_sensitive_data("user") { config['username'] }
      c.filter_sensitive_data("pass") { config['password'] }
    end
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

def mock_request(meth, path, options = {})
  config = Squall.config
  uri    = URI.parse(Squall.config[:base_uri])
  url    = "#{uri.scheme}://#{config[:username]}:#{config[:password]}@#{uri.host}:#{uri.port}#{path}"
  FakeWeb.register_uri(meth, url, {:content_type => 'application/json'}.merge(options))
end