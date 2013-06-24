require 'spec_helper'

describe Squall::VirtualMachine do
  before(:each) do
    @virtual_machine = Squall::VirtualMachine.new
    @valid = {label: 'testmachine', hostname: 'testmachine', memory: 512, cpus: 1,
              cpu_shares: 10, primary_disk_size: 10, template_id: 1}
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

  describe "#show" do
    use_vcr_cassette "virtual_machine/show"

    it "returns a virtual_machine" do
      virtual_machine = @virtual_machine.show(1)
      virtual_machine.keys.should include(*@keys)
      virtual_machine['label'].should == 'bob'
    end
  end

  describe "#create" do
    use_vcr_cassette "virtual_machine/create"

    it "creates a virtual_machine" do
      pending "broken in OnApp (triggering the Network Interfaces error): see README (and update when fixed)" do
        virtual_machine = @virtual_machine.create(@valid)
        @valid.each do |k,v|
          virtual_machine[k].should == @valid[k.to_s]
        end
      end
    end
  end

  describe "#build" do
    use_vcr_cassette "virtual_machine/build"

    it "builds the VM" do
      build = @virtual_machine.build(72, template_id: 1)

      @virtual_machine.success.should be_true
    end
  end

  describe "#edit" do
    use_vcr_cassette "virtual_machine/edit"

    it "updates the label" do
      virtual_machine = @virtual_machine.edit(1, label: 'testing')
      @virtual_machine.success.should be_true
      virtual_machine['label'].should == 'testing'
    end
  end

  describe "#change_owner" do
    use_vcr_cassette "virtual_machine/change_owner"

    pending "this should raise a 422 on OnApp's side, but it's currently raising a 500 which causes HTTParty to explode, see README (and update when fixed)" do
      it "returns error on unknown user" do
        expect { @virtual_machine.change_owner(1, 2) }.to raise_error(Squall::ServerError)
        @virtual_machine.success.should be_false
      end
    end

    it "changes the user" do
      result = @virtual_machine.change_owner(1, 2)
      @virtual_machine.success.should be_true

      result['user_id'].should == 2
    end
  end

  describe "#change_password" do
    use_vcr_cassette "virtual_machine/change_password"

    it "changes the password" do
      result = @virtual_machine.change_password(1, 'passwordsareimportant')
      @virtual_machine.success.should be_true
    end
  end

  describe "#set_ssh_keys" do
    use_vcr_cassette "virtual_machine/set_ssh_keys"

    it "sets the SSH keys" do
      result = @virtual_machine.set_ssh_keys(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#migrate" do
    use_vcr_cassette "virtual_machine/migrate"

    it "changes the hypervisor" do
      pending "Broken in OnApp" do
        result = @virtual_machine.migrate(1, destination: 2)
        @virtual_machine.success.should be_true
        result['virtual_machine']['hypervisor_id'].should == 2
      end
    end
  end

  describe "#set_vip" do
    use_vcr_cassette "virtual_machine/set_vip"

    it "deletes a virtual_machine" do
      @virtual_machine.set_vip(1)
      @virtual_machine.success.should be_true
    end

    it "sets the vip status to false if currently true" do
      pending "No way to actually test this without being able to interact with server state" do
        result = @virtual_machine.set_vip(1)
        result['virtual_machine']['vip'].should be_false
        flunk("currently untestable, so make sure it doesn't pass by accident")
      end
    end
  end

  describe "#delete" do
    use_vcr_cassette "virtual_machine/delete"

    it "deletes a virtual_machine" do
      virtual_machine = @virtual_machine.delete(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#resize" do
    use_vcr_cassette "virtual_machine/resize"

    it "resizes a virtual_machine" do
      virtual_machine = @virtual_machine.resize(1, memory: 1000)
      @virtual_machine.success.should be_true

      virtual_machine['memory'].should == 1000
    end
  end

  describe "#suspend" do
    use_vcr_cassette "virtual_machine/suspend"

    it "suspends a virtual_machine" do
      virtual_machine = @virtual_machine.suspend(1)
      virtual_machine['suspended'].should be_true
    end
  end

  describe "#unlock" do
    use_vcr_cassette "virtual_machine/unlock"

    it "unlocks a virtual_machine" do
      virtual_machine = @virtual_machine.unlock(1)
      virtual_machine['locked'].should be_false
    end
  end

  describe "#startup" do
    use_vcr_cassette "virtual_machine/startup"

    it "startups a virtual_machine" do
      @virtual_machine.startup(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#shutdown" do
    use_vcr_cassette "virtual_machine/shutdown"

    it "will shutdown a virtual_machine" do
      virtual_machine = @virtual_machine.shutdown(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#stop" do
    use_vcr_cassette "virtual_machine/stop"

    it "will stop a virtual_machine" do
      virtual_machine = @virtual_machine.stop(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#reboot" do
    use_vcr_cassette "virtual_machine/reboot"

    it "will reboot a virtual_machine" do
      virtual_machine = @virtual_machine.reboot(1)
      @virtual_machine.success.should be_true
    end

    it "reboots in recovery" do
      hash = [:post, "/virtual_machines/1/reboot.json", {query: {mode: :recovery}}]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.reboot 1, true
    end
  end

  describe "#segregate" do
    use_vcr_cassette "virtual_machine/segregate"

    it "segregates the VMS with given ids" do
      result = @virtual_machine.segregate(1, 2)
      @virtual_machine.success.should be_true
    end
  end

  describe "#console" do
    use_vcr_cassette "virtual_machine/console"

    it "will reboot a virtual_machine" do
      pending "broken on OnApp (returning 500)" do
        virtual_machine = @virtual_machine.console(1)
        @virtual_machine.success.should be_true
      end
    end
  end

  describe "#stats" do
    use_vcr_cassette "virtual_machine/stats"

    it "will stop a virtual_machine" do
      pending "broken on OnApp (returning 500)" do
        virtual_machine = @virtual_machine.stats(1)
        @virtual_machine.success.should be_true
      end
    end
  end
end
