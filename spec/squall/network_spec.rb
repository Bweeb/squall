require 'spec_helper'

describe Squall::Network do
  before(:each) do
    default_config
    @network = Squall::Network.new
    @keys = ["label", "created_at", "updated_at", "network_group_id", "vlan", "id", "identifier"]
  end

  describe "#list" do
    use_vcr_cassette "network/list"
    it "returns a network list" do
      networks = @network.list
      networks.size.should be(2)
    end

    it "contains first networks data" do
      network = @network.list.first
      network.keys.should include(*@keys)
      network['label'].should == 'Test'
    end
  end

  describe "#edit" do
    use_vcr_cassette 'network/edit'
    it "requires an id" do
      expect { @network.edit }.to raise_error(ArgumentError)
      @network.success.should be_false
    end

    it "errors on invalid params" do
      expect { @network.edit(1, :what => 1) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "accepts valid params" do
      @network.edit(1, :label => 'one')
      @network.success.should be_true

      @network.edit(1, :network_group_id => 1)
      @network.success.should be_true

      @network.edit(1, :identifier => 'lolzsdfds')
      @network.success.should be_true

      @network.edit(1, :vlan => 1)
      @network.success.should be_true

      @network.edit(1, :label => 'two', :vlan => 2, :identifier => 'woah')
      @network.success.should be_true
    end

    it "404s on not found" do
      expect { @network.edit(404) }.to raise_error(Squall::NotFound)
      @network.success.should be_false
    end
  end

  describe "#create" do
    use_vcr_cassette "network/create"
    it "requires label" do
      requires_attr(:label) { @network.create }
    end

    it "raises error on duplicate account" do
      pending "Broken in OnApp" do
        expect { 
          @network.create(:label => 'networktaken')
        }.to raise_error(Squall::RequestError)
        @network.errors['label'].should include("has already been taken")
      end
    end

    it "raises error on invalid params" do
      expect { 
        @network.create(:what => 'networktaken', :label => 'wut')
      }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "creates a network" do
      network = @network.create(:label => 'newnetwork', :vlan => 1, :identifier => 'newnetworkid')
      @network.success.should be_true

      network['label'].should == 'newnetwork'
      network['vlan'].should == 1
      network['identifier'].should == 'newnetworkid'

      network = @network.create(:label => 'newnetwork')
      network['label'].should == 'newnetwork'
      network['vlan'].should be_nil
      @network.success.should be_true

      network = @network.create(:label => 'newnetwork', :vlan => 2)
      network['label'].should == 'newnetwork'
      network['vlan'].should == 2
      @network.success.should be_true

      network = @network.create(:label => 'newnetwork', :identifier => 'something')
      network['label'].should == 'newnetwork'
      network['identifier'].should == 'something'
      @network.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette 'network/delete'
    it "requires an id" do
      expect { @network.delete }.to raise_error(ArgumentError)
      @network.success.should be_false
    end

    it "404s on not found" do
      expect { @network.delete(404) }.to raise_error(Squall::NotFound)
      @network.success.should be_false
    end

    it "deletes the network" do
      delete = @network.delete(16)
      @network.success.should be_true
    end
  end
end
