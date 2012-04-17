require 'spec_helper'

describe Squall::VirtualMachine do
  before(:each) do
    @virtual_machine = Squall::VirtualMachine.new
    @valid = {:label => 'testmachine', :hostname => 'testmachine', :memory => 512, :cpus => 1,
              :cpu_shares => 10, :primary_disk_size => 10, :template_id => 1}
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
    it "requires an id" do
      expect { @virtual_machine.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.show(404) }.to raise_error(Squall::NotFoundError)
    end

    it "returns a virtual_machine" do
      virtual_machine = @virtual_machine.show(1)
      virtual_machine.keys.should include(*@keys)
      virtual_machine['label'].should == 'bob'
    end
  end

  describe "#create" do
    use_vcr_cassette "virtual_machine/create"
    #  validates :label, :hypervisor_id, :hostname, :memory, :cpus, :presence => true
    it "requires label" do
      requires_attr(:label) { @virtual_machine.create }
    end

    it "requires hostname" do
      requires_attr(:hostname) {
        @virtual_machine.create(:label => @valid[:label])
      }
    end

    it "requires memory" do
      requires_attr(:memory) {
        @virtual_machine.create(:label => @valid[:label], :hostname => @valid[:hostname])
      }
    end

    it "requires cpus" do
      requires_attr(:cpus) {
        @virtual_machine.create(:label => @valid[:label], :hostname => @valid[:hostname],
                                :memory => @valid[:memory])
      }
    end

    it "requires cpu_shares" do
      requires_attr(:cpu_shares) {
        @virtual_machine.create(:label => @valid[:label], :hostname => @valid[:hostname],
                                :memory => @valid[:memory], :cpus => @valid[:cpu_shares])
      }
    end

    it "requires primary_disk_size" do
      requires_attr(:primary_disk_size) {
        @virtual_machine.create(:label => @valid[:label], :hostname => @valid[:hostname],
                                :memory => @valid[:memory], :cpus => @valid[:cpu_shares],
                                :cpu_shares => @valid[:cpu_shares])
      }
    end

    it "raises error on unknown params" do
      expect {
        @virtual_machine.create(@valid.merge(:what => 'what'))
      }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "allows all optional params" do
      optional = [:swap_disk_size,
                  :primary_network_id,
                  :required_automatic_backup,
                  :rate_limit,
                  :required_ip_address_assignment,
                  :required_virtual_machine_build,
                  :admin_note,
                  :note,
                  :allowed_hot_migrate,
                  :hypervisor_id,
                  :initial_root_password,
                  :hypervisor_group_id
      ]

      @virtual_machine.should_receive(:request).exactly(optional.size).times.and_return Hash.new('virtual_machine' => [])
      optional.each do |param|
        @virtual_machine.create(@valid.merge(param => "test"))
      end
    end

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
    it "requires an id" do
      expect { @virtual_machine.build }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "accepts :template_id and :required_startup" do
      hash = [:post, "/virtual_machines/1/build.json", {:query=>{:virtual_machine=>{:template_id=>1, :required_startup=>1}}}]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.build(1, :template_id => 1, :required_startup => 1)
    end

    it "raises error on unknown params" do
      expect { @virtual_machine.build(1, :template_id => 1, :asdf => 1) }.to raise_error(ArgumentError, 'Unknown params: asdf')
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.build(404, :template_id => 1) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "builds the VM" do
      build = @virtual_machine.build(72, :template_id => 1)

      @virtual_machine.success.should be_true
    end
  end

  describe "#edit" do
    use_vcr_cassette "virtual_machine/edit"

    it "requires an id" do
      expect { @virtual_machine.edit }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "raises error on unknown params" do
      expect { @virtual_machine.edit(1, :blah => 1) }.to raise_error(ArgumentError, 'Unknown params: blah')
      @virtual_machine.success.should be_false
    end

    it "404s on not found" do
      expect { @virtual_machine.edit(404, :label => 1) }.to raise_error(Squall::NotFoundError)
    end

    it "accepts all valid keys" do
      keys = [:label,
              :hypervisor_id,
              :hostname,
              :memory,
              :cpus,
              :cpu_shares,
              :primary_disk_size,
              :cpu_shares,
              :swap_disk_size,
              :primary_network_id,
              :required_automatic_backup,
              :rate_limit,
              :required_ip_address_assignment,
              :required_virtual_machine_build,
              :admin_note,
              :note,
              :allowed_hot_migrate,
              :template_id,
              :initial_root_password
      ]
      keys.each do |k|
        opts = @virtual_machine.default_params(k.to_sym => 1)
        args = [:put, '/virtual_machines/1.json', opts]
        @virtual_machine.should_receive(:request).with(*args).once.and_return([])
        @virtual_machine.edit(1, k.to_sym => 1 )
      end
    end

    it "updates the label" do
      @virtual_machine.edit(1, :label => 'testing')
      @virtual_machine.success.should be_true
    end
  end

  describe "#change_owner" do
    use_vcr_cassette "virtual_machine/change_owner"
    it "requires an id" do
      expect { @virtual_machine.change_owner }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "requires a user_id" do
      expect { @virtual_machine.change_owner 1 }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "404s on not found" do
      expect { @virtual_machine.change_owner(404, 1) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

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
    it "requires an id" do
      expect { @virtual_machine.change_password }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "requires a password" do
      expect { @virtual_machine.change_password 1 }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "404s on not found" do
      expect { @virtual_machine.change_password(404, 'password') }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "changes the password" do
      result = @virtual_machine.change_password(1, 'passwordsareimportant')
      @virtual_machine.success.should be_true
    end
  end

  describe "#set_ssh_keys" do
    use_vcr_cassette "virtual_machine/set_ssh_keys"
    it "requires an id" do
      expect { @virtual_machine.set_ssh_keys }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "404s on not found" do
      expect { @virtual_machine.set_ssh_keys(404) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "sets the SSH keys" do
      result = @virtual_machine.set_ssh_keys(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#migrate" do
    use_vcr_cassette "virtual_machine/migrate"
    it "requires an id" do
      expect { @virtual_machine.migrate }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "requires a destination" do
      requires_attr(:destination) { @virtual_machine.migrate 1 }
      @virtual_machine.success.should be_false
    end

    it "accepts cold_migrate_on_rollback" do
      hash = [:post, "/virtual_machines/1/migrate.json", {:query => {:virtual_machine => {:destination => 1, :cold_migrate_on_rollback => 1}} }]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.migrate 1, :destination => 1, :cold_migrate_on_rollback => 1
    end

    it "404s on not found" do
      expect { @virtual_machine.migrate(404, :destination => 1) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "404s on unknown destination" do
        expect { @virtual_machine.migrate(1, :destination => 404) }.to raise_error(Squall::NotFoundError)
        @virtual_machine.success.should be_false
    end

    it "changes the hypervisor" do
      pending "Broken in OnApp" do
        result = @virtual_machine.migrate(1, :destination => 2)
        @virtual_machine.success.should be_true
        result['virtual_machine']['hypervisor_id'].should == 2
      end
    end
  end

  describe "#set_vip" do
    use_vcr_cassette "virtual_machine/set_vip"
    it "requires an id" do
      expect { @virtual_machine.set_vip }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.set_vip(404) }.to raise_error(Squall::NotFoundError)
    end

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
    it "requires an id" do
      expect { @virtual_machine.delete }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.delete(404) }.to raise_error(Squall::NotFoundError)
    end

    it "deletes a virtual_machine" do
      virtual_machine = @virtual_machine.delete(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#resize" do
    use_vcr_cassette "virtual_machine/resize"
    it "requires an id" do
      expect { @virtual_machine.resize }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.resize(404, :memory => 1) }.to raise_error(Squall::NotFoundError)
    end

    it "accepts memory" do
      hash = [:post, "/virtual_machines/1/resize.json",  @virtual_machine.default_params(:memory => 1)]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.resize 1, :memory => 1
    end

    it "accepts cpus" do
      hash = [:post, "/virtual_machines/1/resize.json",  @virtual_machine.default_params(:cpus => 1)]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.resize 1, :cpus => 1
    end

    it "accepts cpu_shares" do
      hash = [:post, "/virtual_machines/1/resize.json",  @virtual_machine.default_params(:cpu_shares => 1)]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.resize 1, :cpu_shares => 1
    end

    it "accepts allow_cold_resize" do
      hash = [:post, "/virtual_machines/1/resize.json",  @virtual_machine.default_params(:allow_cold_resize => 1)]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.resize 1, :allow_cold_resize => 1
    end

    it "resizes a virtual_machine" do
      virtual_machine = @virtual_machine.resize(1, :memory => 1000)
      @virtual_machine.success.should be_true

      virtual_machine['memory'].should == 1000
    end

    it "requires at least one option" do
      expect { @virtual_machine.resize(1) }.to raise_error(ArgumentError)
    end
  end

  describe "#suspend" do
    use_vcr_cassette "virtual_machine/suspend"
    it "requires an id" do
      expect { @virtual_machine.suspend }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.suspend(404) }.to raise_error(Squall::NotFoundError)
    end

    it "suspends a virtual_machine" do
      virtual_machine = @virtual_machine.suspend(1)
      virtual_machine['suspended'].should be_true
    end
  end

  describe "#unlock" do
    use_vcr_cassette "virtual_machine/unlock"
    it "requires an id" do
      expect { @virtual_machine.unlock }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.unlock(404) }.to raise_error(Squall::NotFoundError)
    end

    it "unlocks a virtual_machine" do
      virtual_machine = @virtual_machine.unlock(1)
      virtual_machine['locked'].should be_false
    end
  end

  describe "#startup" do
    use_vcr_cassette "virtual_machine/startup"
    it "requires an id" do
      expect { @virtual_machine.startup }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.startup(404) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "startups a virtual_machine" do
      @virtual_machine.startup(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#shutdown" do
    use_vcr_cassette "virtual_machine/shutdown"
    it "requires an id" do
      expect { @virtual_machine.shutdown }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.shutdown(404) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "will shutdown a virtual_machine" do
      virtual_machine = @virtual_machine.shutdown(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#stop" do
    use_vcr_cassette "virtual_machine/stop"
    it "requires an id" do
      expect { @virtual_machine.stop }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.stop(404) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "will stop a virtual_machine" do
      virtual_machine = @virtual_machine.stop(1)
      @virtual_machine.success.should be_true
    end
  end

  describe "#reboot" do
    use_vcr_cassette "virtual_machine/reboot"
    it "requires an id" do
      expect { @virtual_machine.reboot }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.reboot(404) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "will reboot a virtual_machine" do
      virtual_machine = @virtual_machine.reboot(1)
      @virtual_machine.success.should be_true
    end

    it "reboots in recovery" do
      hash = [:post, "/virtual_machines/1/reboot.json", {:query => {:mode => :recovery}}]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.reboot 1, true
    end
  end

  describe "#segregate" do
    use_vcr_cassette "virtual_machine/segregate"
    it "requires an id" do
      expect { @virtual_machine.segregate }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "requires a target_vm_id" do
      expect { @virtual_machine.segregate 1 }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "404s on not found" do
      expect { @virtual_machine.segregate(404, 1) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "returns 404 on unknown target vm id" do
      expect { @virtual_machine.segregate(1, 404) }.to raise_error(Squall::NotFoundError)
      @virtual_machine.success.should be_false
    end

    it "segregates the VMS with given ids" do
      result = @virtual_machine.segregate(1, 2)
      @virtual_machine.success.should be_true
    end
  end

  describe "#console" do
    use_vcr_cassette "virtual_machine/console"
    it "requires an id" do
      expect { @virtual_machine.console }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      pending "broken on OnApp (returning 500)" do
        expect { @virtual_machine.console(404) }.to raise_error(Squall::NotFoundError)
        @virtual_machine.success.should be_false
      end
    end

    it "will reboot a virtual_machine" do
      pending "broken on OnApp (returning 500)" do
        virtual_machine = @virtual_machine.console(1)
        @virtual_machine.success.should be_true
      end
    end
  end

  describe "#stats" do
    use_vcr_cassette "virtual_machine/stats"
    it "requires an id" do
      expect { @virtual_machine.stats }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      pending "broken on OnApp (returning 500)" do
        expect { @virtual_machine.stats(404) }.to raise_error(Squall::NotFoundError)
        @virtual_machine.success.should be_false
      end
    end

    it "will stop a virtual_machine" do
      pending "broken on OnApp (returning 500)" do
        virtual_machine = @virtual_machine.stats(1)
        @virtual_machine.success.should be_true
      end
    end
  end
end
