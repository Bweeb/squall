require 'spec_helper'

describe Squall::Hypervisor do
  before(:each) do
    default_config
    @hv = Squall::Hypervisor.new
  end

  describe "#list" do
    use_vcr_cassette 'hypervisor/list'
    it "returns hypervisors" do
      hvs = @hv.list
      hvs.size.should be(2)

      keys = ["label", "called_in_at", "spare", "created_at", "hypervisor_type",
              "updated_at", "xen_info", "id", "hypervisor_group_id", "enabled", "health",
              "failure_count", "memory_overhead", "online", "locked", "ip_address"]
      first = hvs.first
      first.keys.should include(*keys)
      first['label'].should == 'Testing'
      first['hypervisor_type'].should == 'xen'
    end
  end

  describe "#show" do
    use_vcr_cassette "hypervisor/show"
    it "requires an id" do
      expect { @hv.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid hvs" do
      expect { @hv.show(5) }.to raise_error(Squall::NotFound)
    end

    it "returns a hv" do
      hv = @hv.show(1)
      hv['label'].should == 'Testing'
    end
  end

  describe "#create" do
    use_vcr_cassette "hypervisor/create"
    it "requires label" do
      requires_attr(:label) { @hv.create }
      @hv.success.should be_false
    end

    it "requires ip_address" do
      requires_attr(:ip_address) { @hv.create(:label => 'Brand New') }
      @hv.success.should be_false
    end

    it "requires hypervisor_type" do
      requires_attr(:hypervisor_type) { @hv.create(:label => 'Brand New', :ip_address => '222.222.222.222') }
      @hv.success.should be_false
    end

    # The API allows you to commit this value but subsequent
    # saves do not work because of this missing value.
    it "requires memory_overhead" do
      pending "Broken in OnApp"
      requires_attr(:memory_overhead) { @hv.create(:label => 'Brand New', :ip_address => '222.222.222.222', :hypervisor_type => 'xen') }
    end

    it "raises error on duplicate account" do
      expect {
        @hv.create(:label => 'Testing', :ip_address => '123.123.123.123', :hypervisor_type => 'xen')
      }.to raise_error(Squall::RequestError)
      @hv.errors['label'].should include("has already been taken")
      @hv.errors['ip_address'].should include("has already been taken")
      @hv.success.should be_false
    end

    it "creates a hypervisor" do
      create = @hv.create(:label => 'Brand new', :ip_address => '126.126.126.126', :hypervisor_type => 'xen')
      @hv.success.should be_true

      create['label'].should == 'Brand new'
      create['ip_address'].should == '126.126.126.126'
      create['hypervisor_type'].should == 'xen'
    end
  end

  describe "#edit" do
    use_vcr_cassette 'hypervisor/edit'
    it "requires an id" do
      expect { @hv.edit }.to raise_error(ArgumentError)
      @hv.success.should be_false
    end

    it "raises an error with unknown param " do
      expect { @hv.edit(3, :blah => 1)}.to raise_error(ArgumentError)
      @hv.success.should be_false
    end

    it "edits the label" do
      edit = @hv.edit(3, :label => 'Old Gregg')
      @hv.success.should be_true
    end

    it "edits the ip_address" do
      edit = @hv.edit(3, :ip_address => '120.120.120.120')
      @hv.success.should be_true
    end
  end

  describe "#reboot" do
    use_vcr_cassette 'hypervisor/reboot'
    it "requires an id" do
      expect { @hv.reboot }.to raise_error(ArgumentError)
      @hv.success.should be_false
    end

    it "404s on not found" do
      expect { @hv.reboot(404) }.to raise_error(Squall::NotFound)
      @hv.success.should be_false
    end

    it "reboots the hypervisor" do
      reboot = @hv.reboot(1)
      @hv.success.should be_true

      reboot['label'].should == 'Testing'
    end
  end

  describe "#delete" do
    use_vcr_cassette "hypervisor/delete"
    it "requires an id" do
      expect { @hv.delete }.to raise_error(ArgumentError)
    end

    it "404s on not found" do
      expect { @hv.delete(404) }.to raise_error(Squall::NotFound)
      @hv.success.should be_false
    end

    it "returns a hv" do
      @hv.delete(3)
      @hv.success.should be_true
    end
  end
end
