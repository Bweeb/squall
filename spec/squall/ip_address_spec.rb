require 'spec_helper'

describe Squall::IpAddress do
  before(:each) do
    @ip = Squall::IpAddress.new
    @keys = ["netmask", "disallowed_primary", "address", "created_at", "updated_at", "network_id",
    "network_address", "broadcast", "id", "gateway"]
  end

  describe "#list" do
    use_vcr_cassette 'ipaddress/list'

    it "requires network_id" do
      expect { @ip.list }.to raise_error(ArgumentError)
    end

    it "returns ip_addresses" do
      ips = @ip.list(1)
      ips.should be_an(Array)
    end

    it "contains ip address data" do
      ips = @ip.list(1)
      ips.all?.should be_true
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

    it "edits the IpAddress" do
      ip = @ip.edit(1, 1, ip_params)
      @ip.success.should be_true
    end
  end

  describe "#create" do
    use_vcr_cassette 'ipaddress/create'

    it "raises ArgumentError without network_id" do
      expect { @ip.create }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError without required options" do
      expect { @ip.create(1, {}) }.to raise_error(ArgumentError)
    end

    it "creates a new IP" do
      new_ip = @ip.create(1,
        :address         => '109.123.91.24',
        :netmask         => '255.255.255.194',
        :broadcast       => '109.123.91.129',
        :network_address => '109.123.91.66',
        :gateway         => '109.123.91.67'
      )

      @ip.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette 'ipaddress/delete'

    it "raises ArgumentError without network_id or id" do
      expect { @ip.delete }.to raise_error(ArgumentError)
      expect { @ip.delete(1) }.to raise_error(ArgumentError)
    end

    it "deletes the IP" do
      @ip.delete(1, 1)
      @ip.success.should be_true
    end
  end
end
