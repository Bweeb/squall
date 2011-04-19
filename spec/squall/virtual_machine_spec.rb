require 'spec_helper'

describe Squall::VirtualMachine do
  before(:each) do
    default_config
    @virtual_machine = Squall::VirtualMachine.new
    @keys = ["monthly_bandwidth_used", "cpus", "label", "created_at", "operating_system_distro", 
      "cpu_shares", "operating_system", "template_id", "allowed_swap", "local_remote_access_port", 
      "memory", "updated_at", "allow_resize_without_reboot", "recovery_mode", "hypervisor_id", "id", 
      "xen_id", "user_id", "total_disk_size", "booted", "hostname", "template_label", "identifier", 
      "initial_root_password", "min_disk_size", "remote_access_password", "built", "locked", "ip_addresses"]
  end

  describe "#list" do
    use_vcr_cassette "virtual_machine/list"

    it "returns a virtual_machine list" do
      virtual_machines = @virtual_machine.list
      virtual_machines.size.should be(2)
    end

    it "contains first virtual_machines data" do
      virtual_machine = @virtual_machine.list.first
      virtual_machine.keys.should include(*@keys)
      virtual_machine['label'].should == 'ohhai.server.com'
    end
  end
end
