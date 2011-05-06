require 'spec_helper'

describe Squall::IpAddress do
  before(:each) do
    default_config
    @ip = Squall::IpAddress.new
    @keys = ["netmask", "disallowed_primary", "address", "created_at", "updated_at", "network_id", 
    "network_address", "broadcast", "id", "gateway"]
  end

  describe "#list" do
    use_vcr_cassette 'ipaddress/list'

    it "requires network_id" do
      expect { @ip.list }.to raise_error(ArgumentError)
    end

    it "404s on invalid network" do
      expect { @ip.list(404) }.to raise_error(Squall::NotFound)
    end

    it "returns ip_addresses" do
      ips = @ip.list(1)
      ips.size.should be(2)

      first = ips.first
      first.keys.should include(*@keys)
      first['netmask'].should == '255.255.255.0'
      first['address'].should == '127.2.2.2'
    end
  end
end
