require 'spec_helper'

describe Squall::User do
  before(:each) do
    default_config
    @keys = ["total_amount", "activated_at", "created_at", "memory_available", "remember_token_expires_at",
            "used_disk_size", "deleted_at", "updated_at", "used_ip_addresses", "activation_code", "used_cpu_shares",
            "used_cpus", "group_id", "id", "used_memory", "payment_amount", "last_name", "remember_token",
            "disk_space_available", "time_zone", "outstanding_amount", "login", "roles", "email", "first_name"]
    @user = Squall::User.new
    @valid = {:login => 'user', :email => 'me@example.com', :password => 'CD2480A3413F',
              :first_name => 'John', :last_name => 'Doe', :group_id => 10 }
  end

  describe "#create" do
    use_vcr_cassette "user/create"
    it "requires login" do
      requires_attr(:login) { @user.create }
    end

    it "requires email" do
      requires_attr(:email) { @user.create(:login => @valid[:login]) }
    end

    it "requires password" do
      requires_attr(:password) {
        @user.create(:login => @valid[:login], :email => @valid[:email])
      }
    end

    it "raises error on duplicate account" do
      expect {
        @user.create(@valid.merge(:login => 'usertaken', :email => 'metaken@example.com'))
      }.to raise_error(Squall::RequestError)
      @user.errors['login'].should include("has already been taken")
      @user.errors['email'].should include("has already been taken")
    end

    it "creates a user" do
      user = @user.create(@valid)
      user['email'].should      == @valid['email']
      user['first_name'].should == @valid['first_name']
      user['last_name'].should  == @valid['last_name']
      user['group_id'].should   == @valid['group_id']
    end
  end

  describe "#list" do
    use_vcr_cassette "user/list"
    it "returns a user list" do
      users = @user.list
      users.size.should be(2)
    end

    it "contains first users data" do
      user = @user.list.first
      user.keys.should include(*@keys)
      user['email'].should == "user@example.com"
    end
  end

  describe "#show" do
    use_vcr_cassette "user/show"
    it "requires an id" do
      expect { @user.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid users" do
      expect { @user.show(5) }.to raise_error(Squall::NotFound)
    end

    it "returns a user" do
      user = @user.show(1)
      user['login'].should == 'user'
    end
  end

  describe "#generate_api_key" do
    use_vcr_cassette "user/generate_api_key"
    it "requires an id" do
      expect { @user.generate_api_key }.to raise_error(ArgumentError)
    end

    it "generates a new key" do
      pending "Broken in OnApp" do
        user = @user.generate_api_key(1)
        user['api_key'].should == '7d97e98f8af710c7e7fe703abc8f639e0ee507c4'
      end
    end
  end

  describe "#suspend" do
    use_vcr_cassette "user/suspend"
    it "requires an id" do
      expect { @user.suspend }.to raise_error(ArgumentError)
    end

    it "suspends a user" do
      user = @user.suspend(2)
      user['status'].should == "suspended"
    end
  end

  describe "#activate" do
    use_vcr_cassette "user/activate"
    it "requires an id" do
      expect { @user.activate }.to raise_error(ArgumentError)
    end

    it "activates a user" do
      user = @user.activate(2)
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

    it "deltes a user" do
      delete = @user.delete(6)
      delete.should be_true
    end

    it "returns NotFound for missing user" do
      expect { @user.delete(22222) }.to raise_error(Squall::NotFound)
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

  describe "#edit_role" do
    use_vcr_cassette "user/edit_role"
    it "requires an id" do
      expect { @user.edit_role }.to raise_error(ArgumentError)
    end

    it "404s on not found" do
      expect { @user.edit_role(500, nil) }.to raise_error(Squall::NotFound)
    end

    it "edits one role for a user" do
      @user.edit_role(7, 4)
      @user.success.should be_true
    end

    it "edits two roles for a user" do
      @user.edit_role(7, 4, 2)
      @user.success.should be_true
    end
  end
end
