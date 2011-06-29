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

def mock_request(meth, path, options = {})
  config = Squall.config
  uri    = URI.parse(Squall.config[:base_uri])
  url    = "#{uri.scheme}://#{config[:username]}:#{config[:password]}@#{uri.host}:#{uri.port}#{path}"
  FakeWeb.register_uri(meth, url, {:content_type => 'application/json'}.merge(options))
end

RSpec::Matchers.define :have_attr_accessor do |attribute|
  match do |object|
    object.respond_to?(attribute) && object.respond_to?("#{attribute}=")
  end

  description do
    "have attr_accessor :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_reader do |attribute|
  match do |object|
    object.respond_to? attribute
  end

  description do
    "have attr_reader :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_writer do |attribute|
  match do |object|
    object.respond_to? "#{attribute}="
  end

  description do
    "have attr_writer :#{attribute}"
  end
end
