require 'spec_helper'

describe Squall::IpAddressJoin do
  before(:each) do
    @join = Squall::IpAddressJoin.new
  end

  describe "#list" do
    use_vcr_cassette 'ipaddress_join/list'

    it "returns list of ip_addresses" do
      ips = @join.list(1)
      ips.should be_an(Array)
    end

    it "contains IP address data" do
      ips = @join.list(1)
      ips.all?.should be_true
    end
  end

  describe "#assign" do
    use_vcr_cassette "ipaddress_join/assign"

    it "assigns the IP join" do
      join = @join.assign(1, {ip_address_id: 1, network_interface_id: 1})
      @join.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette "ipaddress_join/delete"

    it "deletes the IP join" do
      @join.delete(1, 1)
      @join.success.should be_true
    end
  end
end
