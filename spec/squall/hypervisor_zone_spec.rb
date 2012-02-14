require 'spec_helper'

describe Squall::HypervisorZone do
  before(:each) do
    @hypervisor_zone = Squall::HypervisorZone.new
    @valid = {:label => "My zone"}
  end

  describe "#list" do
    use_vcr_cassette "hypervisor_zones/list"
    
    it "returns all hypervisor zones" do
      hypervisor_zoness = @hypervisor_zone.list
      hypervisor_zoness.should be_an(Array)
    end

    it "contains the hypervisor zone data" do
      hypervisor_zoness = @hypervisor_zone.list
      hypervisor_zoness.all? {|w| w.is_a?(Hash) }.should be_true
    end
  end
  
  describe "#show" do
    use_vcr_cassette "hypervisor_zones/show"
    it "requires an id" do
      expect { @hypervisor_zone.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid hypervisor zone id" do
      expect { @hypervisor_zone.show(404) }.to raise_error(Squall::NotFound)
    end

    it "returns a hypervisor zone" do
      hypervisor_zones = @hypervisor_zone.show(1)
      hypervisor_zones.should be_a(Hash)
    end
  end
  
  describe "#create" do
    use_vcr_cassette "hypervisor_zones/create"
    it "requires label" do
      invalid = @valid.reject{|k,v| k == :label }
      requires_attr(:label) { @hypervisor_zone.create(invalid) }
    end
    
    it "raises error on unknown params" do
      expect { @hypervisor_zone.create(@valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "creates a hypervisor zone" do
      @hypervisor_zone.create(@valid)
      @hypervisor_zone.success.should be_true
    end
  end
  
  describe "#edit" do
    use_vcr_cassette "hypervisor_zones/edit"
    
    it "allows select params" do
      optional = [:label]
      @hypervisor_zone.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @hypervisor_zone.edit(1, param => "test")
      end
    end
    
    it "raises error on unknown params" do
      expect { @hypervisor_zone.edit(1, @valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "edits a hypervisor zone" do
      @hypervisor_zone.edit(1, :label => "Updated zone")
      @hypervisor_zone.success.should be_true
    end
    
    it "raises an error for an invalid hypervisor zone id" do
      expect { @hypervisor_zone.edit(404, @valid) }.to raise_error(Squall::NotFound)
    end
  end
  
  describe "#delete" do
    use_vcr_cassette "hypervisor_zones/delete"
    it "requires an id" do
      expect { @hypervisor_zone.delete }.to raise_error(ArgumentError)
    end

    it "deletes a hypervisor zone" do
      @hypervisor_zone.delete(1)
      @hypervisor_zone.success.should be_true
    end

    it "returns NotFound for invalid hypervisor zone id" do
      expect { @hypervisor_zone.delete(404) }.to raise_error(Squall::NotFound)
    end
  end

end