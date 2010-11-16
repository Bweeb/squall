require 'rubygems'
require 'test/unit'
require 'redgreen'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'squall'
require 'fakeweb'

class Test::Unit::TestCase

  def setup
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    Squall.config('user', 'stupidpass', 'http://example.com/onapp')
  end

  def uri_with_login
      "http://#{Squall.api_user}:#{Squall.api_password}@#{Squall.api_endpoint.host}#{Squall.api_endpoint.path}"
  end

  def stub_json_request(meth, uri, content = nil)
    content = File.read(File.join(File.dirname(__FILE__), "fixtures/#{uri}.json")) if content.nil?
    fake_response = Net::HTTPOK.new('1.1', '200', 'OK') 
    fake_response['Content-Type'] = 'application/json' 
    fake_response.instance_variable_set('@body', content)
    FakeWeb.register_uri(meth, "#{uri_with_login}/#{uri}.json", :content_type => 'application/json', :response => fake_response)
  end

end
