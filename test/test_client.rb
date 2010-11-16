require File.dirname(__FILE__) + '/helper'

class TestClient < Test::Unit::TestCase

  def setup
    super
    @client = Squall::Client.new 
    assert_defaults
  end

  def test_init
    default_options = {:accept => :json, :content_type => 'application/json'}
    assert_equal default_options, @client.instance_variable_get('@default_options')
    assert_equal false, @client.instance_variable_get('@debug')
  end

  def test_debug
    assert_nil RestClient.log
    assert_equal false, @client.instance_variable_get('@debug')

    @client.toggle_debug
    assert_equal true, @client.instance_variable_get('@debug')
    assert_equal STDERR, RestClient.log

    @client.toggle_debug
    assert_nil RestClient.log
    assert_equal false, @client.instance_variable_get('@debug')
  end

  def test_get
    stub_json_request(:get, 'test_get', '["test"]')
    @client.get('test_get')

    assert_equal :get,  @client.request.method
  end

  def test_post
    stub_json_request(:post, 'test_post', '["test"]')
    @client.post('test_post')
    assert_equal :post,  @client.request.method
  end

  def test_put
    stub_json_request(:put, 'test_put', '["test"]')
    @client.put('test_put')
    assert_equal :put,  @client.request.method
  end

  def test_delete
    stub_json_request(:delete, 'test_delete', '["test"]')
    @client.delete('test_delete')
    assert_equal :delete,  @client.request.method
  end

  def test_required_options
    assert_nothing_raised do
      required_options = [:one, :two, :three]
      actual_options   = {:one => 1, :two => 2, :three => 3}
      @client.send(:required_options!, required_options, actual_options)
    end

    assert_nothing_raised do
      required_options = [:one, :two, :three]
      actual_options   = {:one => 1, :two => 2, :three => 3, :four => 4}
      @client.send(:required_options!, required_options, actual_options)
    end

    e = assert_raises ArgumentError do
      required_options = [:one, :two, :three]
      actual_options   = {:one => 1 }
      @client.send(:required_options!, required_options, actual_options)
    end
    assert_match /Missing key\(s\): two, three/, e.message
  end

  def test_valid_options
    assert_nothing_raised do
      accepted = [:one, :two]
      actual   = {:one => 1, :two => 2} 
      @client.send(:valid_options!, accepted, actual)
    end

    e = assert_raises ArgumentError do
      accepted = [:one, :two]
      actual   = {:one => 1, :two => 2, :three => 3} 
      @client.send(:valid_options!, accepted, actual)
    end
    assert_match /Unknown key\(s\): three/, e.message
  end

  def test_uri_with_auth
    assert_equal "http://user:stupidpass@example.com/onapp", @client.send(:uri_with_auth)

    Squall.config('user', 'stupidpass', 'example.com/onapp')
    assert_equal "http://user:stupidpass@example.com/onapp", @client.send(:uri_with_auth)

    Squall.config('user', 'stupidpass', 'https://example.com/onapp')
    assert_equal "https://user:stupidpass@example.com/onapp", @client.send(:uri_with_auth)
  end

  def test_handle_response_success
    stub_json_request(:get, 'handle_response_success', '["response"]')
    @client.get('handle_response_success')

    assert_instance_of RestClient::Request,  @client.request
    assert_instance_of Net::HTTPOK,  @client.result

    assert_equal true,  @client.response.respond_to?(:code)
    assert_equal 200, @client.response.code
    assert_equal ["response"], @client.message
    assert_equal true, @client.successful
    assert_equal '["response"]', @client.response
  end

  def test_handle_response_error
    FakeWeb.register_uri(:get, "#{uri_with_login}/handle_response_error_404.json", 
                         :content_type => 'application/json', :body => '', :status => ["404", "Not Found"])
    @client.get('handle_response_error_404')
    assert_equal "404 Not Found", @client.message
    assert_equal false, @client.successful

    FakeWeb.register_uri(:get, "#{uri_with_login}/handle_response_error_403.json", 
                         :content_type => 'application/json', :body => '', :status => ["403", "Forbidden"])
    @client.get('handle_response_error_403')
    assert_equal "Action is not permitted for that account", @client.message
    assert_equal false, @client.successful

    FakeWeb.register_uri(:get, "#{uri_with_login}/handle_response_error_422.json", 
                         :content_type => 'application/json', :body => '422', :status => ["422", "Failed"])
    @client.get('handle_response_error_422')
    assert_equal "Request Failed: 422", @client.message
    assert_equal false, @client.successful

    FakeWeb.register_uri(:get, "#{uri_with_login}/handle_response_error_500.json", 
                         :content_type => 'application/json', :body => '', :status => ["500", "Failed"])
    e = assert_raises RestClient::InternalServerError do
      @client.get('handle_response_error_500')
    end
    assert_match /Internal Server Error/i, e.message
    assert_equal false, @client.successful
  end

  def assert_defaults
    assert_nil @client.response
    assert_nil @client.result
    assert_nil @client.response
    assert_nil @client.successful
    assert_nil @client.message
  end

end
