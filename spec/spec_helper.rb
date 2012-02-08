require 'yaml'
require 'rspec'
require 'vcr'
require 'squall'

Squall.config_file

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb
  c.default_cassette_options = {:record => :new_episodes}
  c.filter_sensitive_data("Basic <REDACTED>") { |i| [i.request.headers['authorization']].flatten.first }
  c.filter_sensitive_data("<REDACTED>") { |i| [i.response.headers['set-cookie']].flatten.first }
  c.filter_sensitive_data("<URL>") { URI.parse(Squall.config[:base_uri]).host }
  c.filter_sensitive_data("<USER>") { Squall.config[:username] }
  c.filter_sensitive_data("<PASS>") { Squall.config[:password] }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.before(:each) do
    Squall.config_file
  end
  c.after(:each) do
    Squall.reset_config
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