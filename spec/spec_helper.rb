require 'yaml'
require 'rspec'
require 'vcr'
require 'squall'

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb
  if ENV['RERECORD']
    c.default_cassette_options = {record: :all}
  else
    c.default_cassette_options = {record: :none}
  end
  c.filter_sensitive_data("Basic <REDACTED>") { |i| [i.request.headers['authorization']].flatten.first }
  c.filter_sensitive_data("<REDACTED>") { |i| [i.response.headers['set-cookie']].flatten.first }
  c.filter_sensitive_data("<URL>") { URI.parse(Squall.config[:base_uri]).host }
  c.filter_sensitive_data("<USER>") { Squall.config[:username] }
  c.filter_sensitive_data("<PASS>") { Squall.config[:password] }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.before(:each) do
    configure_for_tests
  end
  c.after(:each) do
    Squall.reset_config
  end
end

def configure_for_tests
  if ENV['RERECORD']
    Squall.config_file
  else
    Squall.config do |c|
      c.username "test"
      c.password "test"
      c.base_uri "http://example.com"
    end
  end
end

def mock_request(meth, path, options = {})
  config = Squall.config
  uri    = URI.parse(config[:base_uri])
  url    = "#{uri.scheme}://#{config[:username]}:#{config[:password]}@#{uri.host}:#{uri.port}#{path}"
  FakeWeb.register_uri(meth, url, {content_type: 'application/json'}.merge(options))
end
