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
end
