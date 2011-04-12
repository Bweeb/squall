require 'spec_helper'

describe Squall::User do
  before(:each) do
    default_config
    @user = Squall::User.new
    @valid = {:login => 'user', :email => 'me@example.com', :password => 'CD2480A3413F', 
              :password_confirmation => 'CD2480A3413F', :first_name => 'John', :last_name => 'Doe',
              :group_id => 10 }
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
  end

  describe "#list" do
    use_vcr_cassette "user/list"
    it "returns a user list" do
      users = @user.list
      users.size.should be(2)
    end

    it "contains first users data" do
      keys = ["total_amount", "activated_at", "created_at", "memory_available", "remember_token_expires_at", 
              "used_disk_size", "deleted_at", "updated_at", "used_ip_addresses", "activation_code", "used_cpu_shares", 
              "used_cpus", "group_id", "id", "used_memory", "payment_amount", "last_name", "remember_token", 
              "disk_space_available", "time_zone", "outstanding_amount", "login", "roles", "email", "first_name"]
      user = @user.list.first
      user.keys.should include(*keys)
    end

  end
end