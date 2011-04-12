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
  # c.before(:each) do
  # 	pp Squall.config
  # end
  c.after(:each) do
		Squall.reset_config
	end
end

def default_config
	Squall.config do |c|
		c.base_uri 'http://www.example.com'
		c.username 'user'
		c.password 'pass'
	end
end

def requires_attr(attr, &block)
  expect { block.call }.to raise_error(ArgumentError, /Missing required parameter: #{attr}/i)
end