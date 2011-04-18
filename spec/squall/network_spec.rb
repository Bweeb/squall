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
end
