require 'spec_helper'

describe Squall::User do
  before(:each) do
    @keys = ["total_amount", "activated_at", "created_at", "memory_available", "remember_token_expires_at",
            "used_disk_size", "deleted_at", "updated_at", "used_ip_addresses", "activation_code", "used_cpu_shares",
            "used_cpus", "group_id", "id", "used_memory", "payment_amount", "last_name", "remember_token",
            "disk_space_available", "time_zone", "outstanding_amount", "login", "roles", "email", "first_name"]
    @user = Squall::User.new
    @valid = {:login => 'johndoe', :email => 'johndoe@example.com', :password => 'CD2480A3413F',
              :password_confirmation => 'CD2480A3413F', :first_name => 'John', :last_name => 'Doe' }
  end

  describe "#create" do
    use_vcr_cassette "user/create"
    it "requires login" do
      invalid = @valid.reject{|k,v| k == :login }
      requires_attr(:login) { @user.create(invalid) }
    end

    it "requires email" do
      invalid = @valid.reject{|k,v| k == :email }
      requires_attr(:email) { @user.create(invalid) }
    end

    it "requires password" do
      invalid = @valid.reject{|k,v| k == :password }
      requires_attr(:password) { @user.create(invalid) }
    end
    
    it "requires password confirmation" do
      invalid = @valid.reject{|k,v| k == :password_confirmation }
      requires_attr(:password_confirmation) { @user.create(invalid) }
    end
    
    it "requires first name" do
      invalid = @valid.reject{|k,v| k == :first_name }
      requires_attr(:first_name) { @user.create(invalid) }
    end
    
    it "requires last name" do
      invalid = @valid.reject{|k,v| k == :last_name }
      requires_attr(:last_name) { @user.create(invalid) }
    end
    
    it "allows all optional params" do
      optional = [:role, :time_zone, :locale, :status, :billing_plan_id, :role_ids, :suspend_after_hours, :suspend_at]
      @user.should_receive(:request).exactly(optional.size).times.and_return Hash.new("user" => {})
      optional.each do |param|
        @user.create(@valid.merge(param => "test"))
      end
    end
    
    it "raises error on unknown params" do
      expect { @user.create(@valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "creates a user" do
      user = @user.create(@valid)
      @user.success.should be_true
    end
  end
  
  describe "#edit" do
    use_vcr_cassette "user/edit"
    
    it "allows select params" do
      optional = [:email, :password, :password_confirmation, :first_name, :last_name, :user_group_id, :billing_plan_id, :role_ids, :suspend_at]
      @user.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @user.edit(1, param => "test")
      end
    end
    
    it "raises error on unknown params" do
      expect { @user.edit(1, :what => 'what') }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "edits a user" do
      user = @user.edit(1, :first_name => "Test")
      @user.success.should be_true
    end
  end

  describe "#list" do
    use_vcr_cassette "user/list"
    it "returns a user list" do
      users = @user.list
      users.should be_a(Array)
    end

    it "contains first users data" do
      user = @user.list.first
      user.should be_a(Hash)
    end
  end

  describe "#show" do
    use_vcr_cassette "user/show"
    it "requires an id" do
      expect { @user.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid users" do
      expect { @user.show(404) }.to raise_error(Squall::NotFound)
    end

    it "returns a user" do
      user = @user.show(1)
      user.should be_a(Hash)
    end
  end

  describe "#generate_api_key" do
    use_vcr_cassette "user/generate_api_key"
    it "requires an id" do
      expect { @user.generate_api_key }.to raise_error(ArgumentError)
    end

    it "generates a new key" do
      user = @user.generate_api_key(1)
      user.should be_a(Hash)
    end
  end

  describe "#suspend" do
    use_vcr_cassette "user/suspend"
    it "requires an id" do
      expect { @user.suspend }.to raise_error(ArgumentError)
    end

    it "suspends a user" do
      user = @user.suspend(1)
      user['status'].should == "suspended"
    end
  end

  describe "#activate" do
    use_vcr_cassette "user/activate"
    it "requires an id" do
      expect { @user.activate }.to raise_error(ArgumentError)
    end

    it "activates a user" do
      user = @user.activate(1)
      user['status'].should == "active"
    end

    it "has a unsuspend alias" do
      @user.should respond_to(:unsuspend)
    end
  end

  describe "#delete" do
    use_vcr_cassette "user/delete"
    it "requires an id" do
      expect { @user.delete }.to raise_error(ArgumentError)
    end

    it "deletes a user" do
      @user.delete(1)
      @user.success.should be_true
    end

    it "returns NotFound for missing user" do
      expect { @user.delete(404) }.to raise_error(Squall::NotFound)
    end
  end

  describe "#stats" do
    use_vcr_cassette "user/stats"
    it "requires an id" do
      expect { @user.stats }.to raise_error(ArgumentError)
    end

    it "returns stats" do
      stats = @user.stats(1)
      stats['virtual_machine_id'].should == 55
      keys = ["created_at", "cost", "updated_at", "stat_time", "id",
        "user_id", "vm_billing_stat_id", "billing_stats", "virtual_machine_id"]
      stats.keys.should include *keys
    end
  end

  describe "#virtual_machines" do
    use_vcr_cassette "user/virtual_machines"
    it "requires an id" do
      expect { @user.virtual_machines }.to raise_error(ArgumentError)
    end

    it "404s on not found" do
      pending "Broken in OnApp" do
        expect { @user.virtual_machines(500) }.to raise_error(Squall::NotFound)
      end
    end

    it "returns the virtual_machines" do
      virtual_machines = @user.virtual_machines(1)
      virtual_machines.size.should be(2)
      keys = ["monthly_bandwidth_used", "cpus", "label", "created_at", "operating_system_distro", "cpu_shares",
              "operating_system", "template_id", "allowed_swap", "local_remote_access_port", "memory", "updated_at",
              "allow_resize_without_reboot", "recovery_mode", "hypervisor_id", "id", "xen_id", "user_id", "total_disk_size",
              "booted", "hostname", "template_label", "identifier", "initial_root_password", "min_disk_size",
              "remote_access_password", "built", "locked", "ip_addresses"]
      virtual_machines.first.should include(*keys)
    end
  end
  
end