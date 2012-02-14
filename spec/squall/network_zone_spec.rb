require 'spec_helper'

describe Squall::NetworkZone do
  before(:each) do
    @network_zones = Squall::NetworkZone.new
    @valid = {:label => "My zone"}
  end

  describe "#list" do
    use_vcr_cassette "network_zones/list"
    
    it "returns all data store zones" do
      network_zoness = @network_zones.list
      network_zoness.should be_an(Array)
    end

    it "contains the data store zone data" do
      network_zoness = @network_zones.list
      network_zoness.all? {|w| w.is_a?(Hash) }.should be_true
    end
  end
  
  describe "#show" do
    use_vcr_cassette "network_zones/show"
    it "requires an id" do
      expect { @network_zones.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid data store zone id" do
      expect { @network_zones.show(404) }.to raise_error(Squall::NotFound)
    end

    it "returns a data store zone" do
      network_zones = @network_zones.show(1)
      network_zones.should be_a(Hash)
    end
  end
  
  describe "#create" do
    use_vcr_cassette "network_zones/create"
    it "requires label" do
      invalid = @valid.reject{|k,v| k == :label }
      requires_attr(:label) { @network_zones.create(invalid) }
    end
    
    it "raises error on unknown params" do
      expect { @network_zones.create(@valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "creates a data store zone" do
      @network_zones.create(@valid)
      @network_zones.success.should be_true
    end
  end
  
  describe "#edit" do
    use_vcr_cassette "network_zones/edit"
    
    it "allows select params" do
      optional = [:label]
      @network_zones.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @network_zones.edit(1, param => "test")
      end
    end
    
    it "raises error on unknown params" do
      expect { @network_zones.edit(1, @valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "edits a data store zone" do
      @network_zones.edit(1, :label => "Updated zone")
      @network_zones.success.should be_true
    end
    
    it "raises an error for an invalid data store zone id" do
      expect { @network_zones.edit(404, @valid) }.to raise_error(Squall::NotFound)
    end
  end
  
  describe "#delete" do
    use_vcr_cassette "network_zones/delete"
    it "requires an id" do
      expect { @network_zones.delete }.to raise_error(ArgumentError)
    end

    it "deletes a data store zone" do
      @network_zones.delete(1)
      @network_zones.success.should be_true
    end

    it "returns NotFound for invalid data store zone id" do
      expect { @network_zones.delete(404) }.to raise_error(Squall::NotFound)
    end
  end

end