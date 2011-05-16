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

  describe "#edit" do
    use_vcr_cassette 'ipaddress/edit'

    ip_params = {
      :address         => '109.123.91.67',
      :netmask         => '255.255.255.193',
      :broadcast       => '109.123.91.128',
      :network_address => '109.123.91.65',
      :gateway         => '109.123.91.66'
    }

    it "raises ArgumentError without required arguments" do
      expect { @ip.edit }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError without id argument" do
      expect { @ip.edit(1) }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError without required options" do
      expect { @ip.edit(1, 1, {}) }.to raise_error(ArgumentError)
    end

    it "edits the IpAddress" do
      ip = @ip.edit(1, 1, ip_params)
      @ip.success.should be_true

      pending "OnApp isn't returning the updated IP info right now" do
        ip.keys.should include(*%w[address netmask broadcast network_address gateway])

        ip['address'].should         == '109.123.91.67'
        ip['netmask'].should         == '255.255.255.193'
        ip['broadcast'].should       == '109.123.91.128'
        ip['network_address'].should == '109.123.91.65'
        ip['gateway'].should         == '109.123.91.66'
      end
    end
  end
end
