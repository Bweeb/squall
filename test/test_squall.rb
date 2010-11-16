require File.dirname(__FILE__) + '/helper'

class TestSquall < Test::Unit::TestCase

  def test_config
    url = 'http://example.com/onapp'
    assert_equal 'user', Squall.api_user
    assert_equal 'stupidpass', Squall.api_password
    assert_not_nil Squall.api_endpoint
    assert_equal URI.parse(url), Squall.api_endpoint
  end
end
