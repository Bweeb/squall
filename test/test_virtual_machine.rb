require File.dirname(__FILE__) + '/helper'

class TestVirtualMachine < Test::Unit::TestCase
  def setup
    super
    @virtual = Squall::VirtualMachine.new  
  end

  def test_uri_prefix
    assert_equal 'virtual_machines' , Squall::VirtualMachine::URI_PREFIX
  end
  
  def test_list
    stub_json_request(:get, 'virtual_machines')
    vms = @virtual.list
    assert_equal 2, vms.size
    assert_equal 'label1', vms[0]['label']
    assert_equal 'label2', vms[1]['label']

  end
end
