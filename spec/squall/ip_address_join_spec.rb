require 'spec_helper'

describe Squall::IpAddressJoin do
  before(:each) do
    default_config
    @join = Squall::IpAddressJoin.new
  end

  describe "#list" do
    use_vcr_cassette 'ipaddress_join/list'

    it "requires virtual machine ID" do
      expect { @join.list }.to raise_error(ArgumentError)
    end

    it "raises NotFound with an invalid virtual machine ID" do
      expect { @join.list(4040404) }.to raise_error(Squall::NotFound)
    end

    it "returns ip_addresses" do
      ips = @join.list(1)
      ips.size.should == 1

      ip = ips.first
      ip.keys.should include(*%w[ip_address_id network_interface_id ip_address])
    end
  end

  describe "#assign" do
    use_vcr_cassette "ipaddress_join/assign"

    it "raises ArgumentError without required arguments" do
      expect { @join.assign    }.to raise_error(ArgumentError)
      expect { @join.assign(1) }.to raise_error(ArgumentError)
      expect { @join.assign(2) }.to raise_error(ArgumentError)
    end

    it "raises NotFound with an invalid virtual machine ID" do
      expect {
        @join.assign(40404, {
          :ip_address_id        => 1,
          :network_interface_id => 1
        })
      }.to raise_error(Squall::NotFound)
    end

    it "assigns the IP join" do
      join = @join.assign(1, {
        :ip_address_id        => 5,
        :network_interface_id => 1
      })
      @join.success.should be_true
      join['ip_address_id'].should == 5
      join['network_interface_id'].should == 1
      join['virtual_machine_id'].should == 1
    end
  end

  describe "#delete" do
    use_vcr_cassette "ipaddress_join/delete"

    it "raises ArgumentError without required arguments" do
      expect { @join.delete    }.to raise_error(ArgumentError)
      expect { @join.delete(1) }.to raise_error(ArgumentError)
    end

    it "raises NotFound with an invalid ID" do
      expect { @join.delete(123456, 1) }.to raise_error(Squall::NotFound)
    end

    it "deletes the IP join" do
      @join.delete(1, 1)
      @join.success.should be_true
    end
  end
end
