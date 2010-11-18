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
    assert_equal true, @virtual.successful
    assert_instance_of Array, vms
  end

  def test_show
    stub_json_request(:get, 'virtual_machines/1')
    show = @virtual.show(1)
    assert_instance_of Hash, show
    expected = {"monthly_bandwidth_used"=>0, "cpus"=>2, "label"=>"label1", 
                "created_at"=>"2010-11-16T17:37:23Z", "operating_system_distro"=>"rhel", 
                "cpu_shares"=>16, "operating_system"=>"linux", "template_id"=>9, 
                "allowed_swap"=>true, "local_remote_access_port"=>nil, "memory"=>512,
                "updated_at"=>"2010-11-16T17:37:23Z", "allow_resize_without_reboot"=>true,
                "recovery_mode"=>nil, "hypervisor_id"=>1, "id"=>1, "xen_id"=>nil, 
                "user_id"=>5, "booted"=>false, "hostname"=>"label1.example.com", 
                "template_label"=>nil, "total_disk_size"=>6, "identifier"=>"woah", 
                "initial_root_password"=>"password1", "min_disk_size"=>5, "remote_access_password"=>nil,
                "built"=>false, "locked"=>false, "ip_addresses"=>[]}
    assert_equal expected, show
    assert_equal true, @virtual.successful
  end

  def test_edit
    stub_json_request(:put, 'virtual_machines/1', '')
    edit = @virtual.edit(1, :cpus => 1)
    assert_equal true, edit
    assert_equal true, @virtual.successful
    
    e = assert_raises ArgumentError do
      @virtual.edit(1, :what => 1)
    end
    assert_match /Unknown key\(s\): what/, e.message
  end

  def test_create
    params = {:memory => 128, :cpus => 1, :label => 'test_create', :template_id => 1, 
              :hypervisor_id => 1, :initial_root_password => 'hi', :hostname => 'test_create'}

    response = '{"virtual_machine":{"primary_network_id":"1", "cpus":"1", "label":"test_create",
    "cpu_shares":"10", "template_id":"1", "swap_disk_size":"1", "memory":"128",
    "required_virtual_machine_build":"1", "hypervisor_id":"1",
    "required_ip_address_assignment":"1", "rate_limit":"10",
    "primary_disk_size":"5", "hostname":"s",
    "initial_root_password":"hi"} }'

    stub_json_request(:post, 'virtual_machines', response)

    create = @virtual.create(params)
    assert_equal true, create
    assert_equal JSON.parse(response), @virtual.message
  end

  def test_destroy
    stub_json_request(:delete, 'virtual_machines/1', '')
    destroy = @virtual.destroy(1)
    assert_equal true, destroy
  end

  def test_reboot
    stub_json_request(:post, 'virtual_machines/1/reboot', '')
    reboot = @virtual.reboot(1)
    assert_equal true, reboot
  end

  def test_boot
    stub_json_request(:post, 'virtual_machines/1/startup', '')
    boot = @virtual.boot(1)
    assert_equal true, boot
  end

  def test_shutdown
    stub_json_request(:post, 'virtual_machines/1/stop', '')
    shutdown = @virtual.shutdown(1)
    assert_equal true, shutdown
  end

  def test_search
    stub_json_request(:get, 'virtual_machines')
    search = @virtual.search('label2')
    assert_equal 1, search.size

    search = @virtual.search('label2', :label)
    assert_equal 1, search.size

    search = @virtual.search('label', :label)
    assert_equal 2, search.size

    search = @virtual.search(1, :hypervisor_id)
    assert_equal 2, search.size
  end

end
