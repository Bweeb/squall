require 'spec_helper'

describe Squall::VirtualMachine do
  before(:each) do
    default_config
    @virtual_machine = Squall::VirtualMachine.new
    @valid = {:label => 'testmachine', :hypervisor_id => 5, :hostname => 'testmachine', :memory => 512, :cpus => 1,
              :cpu_shares => 10, :primary_disk_size => 10}
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
      expect { @virtual_machine.show(404) }.to raise_error(Squall::NotFound)
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

    it "requires hypervisor_id" do
      requires_attr(:hypervisor_id) { @virtual_machine.create(:label => @valid[:label]) }
    end

    it "requires hostname" do
      requires_attr(:hostname) {
        @virtual_machine.create(:label => @valid[:label],  :hypervisor_id => @valid[:hypervisor_id])
      }
    end

    it "requires memory" do
      requires_attr(:memory) {
        @virtual_machine.create(:label => @valid[:label],  :hypervisor_id => @valid[:hypervisor_id], :hostname => @valid[:hostname])
      }
    end

    it "requires cpus" do
      requires_attr(:cpus) {
        @virtual_machine.create(:label => @valid[:label],  :hypervisor_id => @valid[:hypervisor_id], :hostname => @valid[:hostname],
                                :memory => @valid[:memory])
      }
    end

    it "requires cpu_shares" do
      requires_attr(:cpu_shares) {
        @virtual_machine.create(:label => @valid[:label],  :hypervisor_id => @valid[:hypervisor_id], :hostname => @valid[:hostname],
                                :memory => @valid[:memory], :cpus => @valid[:cpu_shares])
      }
    end

    it "requires primary_disk_size" do
      requires_attr(:primary_disk_size) {
        @virtual_machine.create(:label => @valid[:label],  :hypervisor_id => @valid[:hypervisor_id],
                                :hostname => @valid[:hostname], :memory => @valid[:memory], :cpus => @valid[:cpu_shares],
                                :cpu_shares => @valid[:cpu_shares])
      }
    end

    it "raises error on unknown params" do
      expect {
        @virtual_machine.create(:label => @valid[:label],  :hypervisor_id => @valid[:hypervisor_id], :hostname => @valid[:hostname],
                                :memory => @valid[:memory], :cpus => @valid[:cpus], :cpu_shares => @valid[:cpu_shares], :what => 'what')
      }.to raise_error(ArgumentError, 'Missing required params: primary_disk_size')
    end

    it "allows all optional params" do
      optional = [:cpu_shares,
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

      @virtual_machine.should_receive(:request).exactly(optional.size).times.and_return Hash.new('virtual_machine' => [])
      optional.each do |k,v|
        @virtual_machine.create(@valid.merge(k.to_sym => v))
      end
    end

    it "creates a virtual_machine" do
      virtual_machine = @virtual_machine.create(@valid)
      @valid.each do |k,v|
        virtual_machine[k].should == @valid[k.to_s]
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
      expect { @virtual_machine.build(1, :asdf => 1) }.to raise_error(ArgumentError, 'Unknown params: asdf')
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.build(404) }.to raise_error(Squall::NotFound)
      @virtual_machine.success.should be_false
    end

    it "builds the VM" do
      build = @virtual_machine.build(72)

      @virtual_machine.success.should be_true
      build['label'].should == 'Testingagain'
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
      expect { @virtual_machine.edit(404, :label => 1) }.to raise_error(Squall::NotFound)
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
      expect { @virtual_machine.change_owner(404, 1) }.to raise_error(Squall::NotFound)
      @virtual_machine.success.should be_false
    end

    it "returns error on unknown user" do
      expect { @virtual_machine.change_owner(1, 404) }.to raise_error(Squall::ServerError)
      @virtual_machine.success.should be_false
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
      expect { @virtual_machine.change_password(404, 'password') }.to raise_error(Squall::NotFound)
      @virtual_machine.success.should be_false
    end

    it "changes the password" do
      result = @virtual_machine.change_password(1, 'passwordsareimportant')
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
      hash = [:post, "/virtual_machines/1/migrate.json", {:query => {:destination => 1, :cold_migrate_on_rollback => 1} }]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.migrate 1, :destination => 1, :cold_migrate_on_rollback => 1
    end

    it "404s on not found" do
      expect { @virtual_machine.migrate(404, :destination => 1) }.to raise_error(Squall::NotFound)
      @virtual_machine.success.should be_false
    end

    it "returns error on unknown destination" do
      pending "Broken in OnApp" do
        expect { @virtual_machine.migrate(1, :destination => 404) }.to raise_error(Squall::ServerError)
        @virtual_machine.success.should be_false
      end
    end

    it "changes the destination" do
      pending "Broken in OnApp" do
        result = @virtual_machine.migrate(1, :destination => 2)
        @virtual_machine.success.should be_true
        result['hypervisor_id'].should == 2
      end
    end
  end

  describe "#delete" do
    use_vcr_cassette "virtual_machine/delete"
    it "requires an id" do
      expect { @virtual_machine.delete }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.delete(404) }.to raise_error(Squall::NotFound)
    end

    it "deletes a virtual_machine" do
      virtual_machine = @virtual_machine.delete(2)
      @virtual_machine.success.should be_true
    end
  end

  describe "#resize" do
    use_vcr_cassette "virtual_machine/resize"
    it "requires an id" do
      expect { @virtual_machine.resize }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.resize(404, :memory => 1) }.to raise_error(Squall::NotFound)
    end

    it "requires memory" do
      @virtual_machine.stub(:request)
      requires_attr(:memory) { @virtual_machine.resize(1) }
    end

    it "accepts allow_migration" do
      hash = [:post, "/virtual_machines/1/resize.json",  @virtual_machine.default_params(:memory => 1, :allow_migration => 1)]
      @virtual_machine.should_receive(:request).with(*hash).once.and_return({'virtual_machine'=>{}})
      @virtual_machine.resize 1, :memory => 1, :allow_migration => 1
    end

    it "resizes a virtual_machine" do
      virtual_machine = @virtual_machine.resize(2, :memory => 1000)
      @virtual_machine.success.should be_true

      virtual_machine['memory'].should == 1000
    end
  end

  describe "#suspend" do
    use_vcr_cassette "virtual_machine/suspend"
    it "requires an id" do
      expect { @virtual_machine.suspend }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.suspend(404) }.to raise_error(Squall::NotFound)
    end

    it "suspends a virtual_machine" do
      virtual_machine = @virtual_machine.suspend(1)
      virtual_machine['suspended'].should be_true
    end
  end

  describe "#unsuspend" do
    use_vcr_cassette "virtual_machine/unsuspend"
    it "requires an id" do
      expect { @virtual_machine.unsuspend }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.unsuspend(404) }.to raise_error(Squall::NotFound)
    end

    it "unsuspends a virtual_machine" do
      virtual_machine = @virtual_machine.unsuspend(1)
      virtual_machine['suspended'].should be_false
    end
  end

  describe "#unlock" do
    use_vcr_cassette "virtual_machine/unlock"
    it "requires an id" do
      expect { @virtual_machine.unlock }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.unlock(404) }.to raise_error(Squall::NotFound)
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
      expect { @virtual_machine.startup(404) }.to raise_error(Squall::NotFound)
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
      expect { @virtual_machine.shutdown(404) }.to raise_error(Squall::NotFound)
      @virtual_machine.success.should be_false
    end

    it "will shutdown a virtual_machine" do
      virtual_machine = @virtual_machine.shutdown(1)
      @virtual_machine.success.should be_true
      virtual_machine['id'].should == 1
    end
  end

  describe "#stop" do
    use_vcr_cassette "virtual_machine/stop"
    it "requires an id" do
      expect { @virtual_machine.stop }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.stop(404) }.to raise_error(Squall::NotFound)
      @virtual_machine.success.should be_false
    end

    it "will stop a virtual_machine" do
      virtual_machine = @virtual_machine.stop(1)
      @virtual_machine.success.should be_true
      virtual_machine['id'].should == 1
    end
  end

  describe "#reboot" do
    use_vcr_cassette "virtual_machine/reboot"
    it "requires an id" do
      expect { @virtual_machine.reboot }.to raise_error(ArgumentError)
      @virtual_machine.success.should be_false
    end

    it "returns not found for invalid virtual_machines" do
      expect { @virtual_machine.reboot(404) }.to raise_error(Squall::NotFound)
      @virtual_machine.success.should be_false
    end

    it "will reboot a virtual_machine" do
      virtual_machine = @virtual_machine.reboot(1)
      @virtual_machine.success.should be_true
      virtual_machine['id'].should == 1
    end
  end
end
