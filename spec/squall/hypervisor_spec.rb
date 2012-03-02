require 'spec_helper'

describe Squall::Hypervisor do
  before(:each) do
    @hv = Squall::Hypervisor.new
    @valid = {:label => 'A new hypervisor', :ip_address => '127.126.126.126', :hypervisor_type => 'xen'}
  end

  describe "#list" do
    use_vcr_cassette 'hypervisor/list'

    it "returns hypervisors" do
      hvs = @hv.list
      hvs.should be_an(Array)
    end
    
    it "contains hypervisor data" do
      hvs = @hv.list
      hvs.all?.should be_true
    end
    
  end

  describe "#show" do
    use_vcr_cassette "hypervisor/show"
    it "requires an id" do
      expect { @hv.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid hvs" do
      expect { @hv.show(404) }.to raise_error(OnApp::NotFoundError)
    end

    it "returns a hv" do
      @hv.show(1)
      @hv.success.should be_true
    end
  end

  describe "#create" do
    use_vcr_cassette "hypervisor/create"
    it "requires label" do
      invalid = @valid.reject{|k,v| k == :label }
      requires_attr(:label) { @hv.create(invalid) }
      @hv.success.should be_false
    end

    it "requires ip_address" do
      invalid = @valid.reject{|k,v| k == :ip_address }
      requires_attr(:ip_address) { @hv.create(invalid) }
      @hv.success.should be_false
    end

    it "requires hypervisor_type" do
      invalid = @valid.reject{|k,v| k == :hypervisor_type }
      requires_attr(:hypervisor_type) { @hv.create(invalid) }
      @hv.success.should be_false
    end

    it "creates a hypervisor" do
      @hv.create(@valid)
      @hv.success.should be_true
    end
  end

  describe "#edit" do
    use_vcr_cassette 'hypervisor/edit'
    it "requires an id" do
      expect { @hv.edit }.to raise_error(ArgumentError)
      @hv.success.should be_false
    end

    it "raises an error with unknown param " do
      expect { @hv.edit(1, :blah => 1)}.to raise_error(ArgumentError)
      @hv.success.should be_false
    end

    it "edits the hypervisor" do
      edit = @hv.edit(1, :label => 'A new label')
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
      expect { @hv.reboot(404) }.to raise_error(OnApp::NotFoundError)
      @hv.success.should be_false
    end

    it "reboots the hypervisor" do
      reboot = @hv.reboot(1)
      @hv.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette "hypervisor/delete"
    it "requires an id" do
      expect { @hv.delete }.to raise_error(ArgumentError)
    end

    it "404s on not found" do
      expect { @hv.delete(404) }.to raise_error(OnApp::NotFoundError)
      @hv.success.should be_false
    end

    it "returns a hv" do
      @hv.delete(1)
      @hv.success.should be_true
    end
  end
  
  describe "#data_store_joins" do
    use_vcr_cassette "hypervisor/data_store_joins"
    
    it "returns a list of data store joins" do
      joins = @hv.data_store_joins(1)
      joins.should be_an(Array)
    end
    
    it "contains the data store join data" do
      joins = @hv.data_store_joins(1)
      joins.all? {|w| w.is_a?(Hash) }.should be_true
    end
    
  end
  
  describe "#add_data_store_join" do
    use_vcr_cassette "hypervisor/add_data_store_join"
    
    it "adds the data store to the hypervisor zone" do
      @hv.add_data_store_join(1, 1)
      @hv.success.should be_true
    end
    
  end
  
  describe "#remove_data_store_join" do
    use_vcr_cassette "hypervisor/remove_data_store_join"
    
    it "removes the data store from the hypervisor zone" do
      @hv.remove_data_store_join(1, 1)
      @hv.success.should be_true
    end
    
  end
  
  describe "#network_joins" do
    use_vcr_cassette "hypervisor/network_joins"
    
    it "returns a list of network joins" do
      joins = @hv.network_joins(1)
      joins.should be_an(Array)
    end
    
    it "contains the network join data" do
      joins = @hv.network_joins(1)
      joins.all? {|w| w.is_a?(Hash) }.should be_true
    end
    
  end
  
  describe "#add_network_join" do
    use_vcr_cassette "hypervisor/add_network_join"
    
    it "requires network id" do
      requires_attr(:network_id) { @hv.add_network_join(1, :interface => "interface") }
    end
    
    it "requires interface" do
      requires_attr(:interface) { @hv.add_network_join(1, :network_id => 1) }
    end
    
    it "adds the network to the hypervisor zone" do
      @hv.add_network_join(1, :network_id => 1, :interface => "interface")
      @hv.success.should be_true
    end
    
  end
  
  describe "#remove_network_join" do
    use_vcr_cassette "hypervisor/remove_network_join"
    
    it "removes the network from the hypervisor zone" do
      @hv.remove_network_join(1, 1)
      @hv.success.should be_true
    end
    
  end
end
