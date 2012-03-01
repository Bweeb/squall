require 'spec_helper'

describe Squall::NetworkZone do
  before(:each) do
    @network_zone = Squall::NetworkZone.new
    @valid = {:label => "My zone"}
  end

  describe "#list" do
    use_vcr_cassette "network_zones/list"
    
    it "returns all network zones" do
      network_zoness = @network_zone.list
      network_zoness.should be_an(Array)
    end

    it "contains the network zone data" do
      network_zoness = @network_zone.list
      network_zoness.all? {|w| w.is_a?(Hash) }.should be_true
    end
  end
  
  describe "#show" do
    use_vcr_cassette "network_zones/show"
    it "requires an id" do
      expect { @network_zone.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid network zone id" do
      expect { @network_zone.show(404) }.to raise_error(OnApp::NotFoundError)
    end

    it "returns a network zone" do
      network_zones = @network_zone.show(1)
      network_zones.should be_a(Hash)
    end
  end
  
  describe "#create" do
    use_vcr_cassette "network_zones/create"
    it "requires label" do
      invalid = @valid.reject{|k,v| k == :label }
      requires_attr(:label) { @network_zone.create(invalid) }
    end
    
    it "raises error on unknown params" do
      expect { @network_zone.create(@valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "creates a network zone" do
      @network_zone.create(@valid)
      @network_zone.success.should be_true
    end
  end
  
  describe "#edit" do
    use_vcr_cassette "network_zones/edit"
    
    it "allows select params" do
      optional = [:label]
      @network_zone.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @network_zone.edit(1, param => "test")
      end
    end
    
    it "raises error on unknown params" do
      expect { @network_zone.edit(1, @valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "edits a network zone" do
      @network_zone.edit(1, :label => "Updated zone")
      @network_zone.success.should be_true
    end
    
    it "raises an error for an invalid network zone id" do
      expect { @network_zone.edit(404, @valid) }.to raise_error(OnApp::NotFoundError)
    end
  end
  
  describe "#delete" do
    use_vcr_cassette "network_zones/delete"
    it "requires an id" do
      expect { @network_zone.delete }.to raise_error(ArgumentError)
    end

    it "deletes a network zone" do
      @network_zone.delete(1)
      @network_zone.success.should be_true
    end

    it "returns NotFound for invalid network zone id" do
      expect { @network_zone.delete(404) }.to raise_error(OnApp::NotFoundError)
    end
  end

  describe "#attach" do
    use_vcr_cassette "network_zones/attach"
    
    it "requires an id" do
      expect { @network_zone.attach }.to raise_error(ArgumentError)
    end
    
    it "requires a network id" do
      expect { @network_zone.attach(1) }.to raise_error(ArgumentError)
    end
    
    it "returns NotFound error for invalid id" do
      expect { @network_zone.attach(404, 1) }.to raise_error(OnApp::NotFoundError)
    end
    
    it "returns NotFound error for invalid network id" do
      expect { @network_zone.attach(1, 404) }.to raise_error(OnApp::NotFoundError)
    end
    
    it "attaches a network to the network zone" do
      request = @network_zone.attach(1, 2)
      @network_zone.success.should be_true
    end
  end
  
  describe "#detach" do
    use_vcr_cassette "network_zones/detach"
    
    it "requires an id" do
      expect { @network_zone.detach }.to raise_error(ArgumentError)
    end
    
    it "requires a network id" do
      expect { @network_zone.detach(1) }.to raise_error(ArgumentError)
    end
    
    it "returns NotFound error for invalid id" do
      expect { @network_zone.detach(404, 1) }.to raise_error(OnApp::NotFoundError)
    end
    
    it "returns NotFound error for invalid network id" do
      expect { @network_zone.detach(1, 404) }.to raise_error(OnApp::NotFoundError)
    end
    
    it "detaches a network to the network zone" do
      request = @network_zone.detach(1, 2)
      @network_zone.success.should be_true
    end
  end

end