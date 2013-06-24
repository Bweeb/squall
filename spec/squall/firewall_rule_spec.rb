require 'spec_helper'

describe Squall::FirewallRule do
  before(:each) do
    @firewall_rule = Squall::FirewallRule.new
    @valid = {command: "DROP", protocol: "TCP", network_interface_id: 1}
  end

  describe "#list" do
    use_vcr_cassette "firewall_rule/list"

    it "returns a list of firewall rules for a vm" do
      firewall_rules = @firewall_rule.list(1)
      firewall_rules.should be_an(Array)
    end

    it "contains first firewall_rule's data" do
      firewall_rules = @firewall_rule.list(1)
      firewall_rules.all?.should be_true
    end
  end

  describe "#create" do
    use_vcr_cassette "firewall_rule/create"

    it "allows all optional params" do
      optional = [:network_interface_id, :address, :port]
      @firewall_rule.should_receive(:request).exactly(optional.size).times.and_return Hash.new("firewall_rule" => {})
      optional.each do |param|
        @firewall_rule.create(1, @valid.merge(param => "test"))
      end
    end

    it "creates a firewall rule for a virtual machine" do
      @firewall_rule.create(1, @valid)
      @firewall_rule.success.should be_true
    end
  end

  describe "#edit" do
    use_vcr_cassette "firewall_rule/edit"

    it "allows select params" do
      optional = [:command, :protocol, :network_interface_id, :address, :port]
      @firewall_rule.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @firewall_rule.edit(1, 1, param => "test")
      end
    end

    it "edits a firewall rule" do
      @firewall_rule.edit(1, 1, port: 1000)
      @firewall_rule.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette "firewall_rule/delete"

    it "deletes a firewall rule" do
      @firewall_rule.delete(1, 1)
      @firewall_rule.success.should be_true
    end
  end

end
