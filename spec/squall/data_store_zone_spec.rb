require 'spec_helper'

describe Squall::DataStoreZone do
  before(:each) do
    @data_store_zone = Squall::DataStoreZone.new
    @valid = {:label => "My zone"}
  end

  describe "#list" do
    use_vcr_cassette "data_store_zone/list"

    it "returns all data store zones" do
      data_store_zones = @data_store_zone.list
      data_store_zones.should be_an(Array)
    end

    it "contains the data store zone data" do
      data_store_zones = @data_store_zone.list
      data_store_zones.all? {|w| w.is_a?(Hash) }.should be_true
    end
  end

  describe "#show" do
    use_vcr_cassette "data_store_zone/show"
    it "requires an id" do
      expect { @data_store_zone.show }.to raise_error(ArgumentError)
    end

    it "returns a data store zone" do
      data_store_zone = @data_store_zone.show(1)
      data_store_zone.should be_a(Hash)
    end
  end

  describe "#create" do
    use_vcr_cassette "data_store_zone/create"
    it "requires label" do
      invalid = @valid.reject{|k,v| k == :label }
      requires_attr(:label) { @data_store_zone.create(invalid) }
    end

    it "raises error on unknown params" do
      expect { @data_store_zone.create(@valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "creates a data store zone" do
      @data_store_zone.create(@valid)
      @data_store_zone.success.should be_true
    end
  end

  describe "#edit" do
    use_vcr_cassette "data_store_zone/edit"

    it "allows select params" do
      optional = [:label]
      @data_store_zone.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @data_store_zone.edit(1, param => "test")
      end
    end

    it "raises error on unknown params" do
      expect { @data_store_zone.edit(1, @valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "edits a data store zone" do
      @data_store_zone.edit(1, :label => "Updated zone")
      @data_store_zone.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette "data_store_zone/delete"
    it "requires an id" do
      expect { @data_store_zone.delete }.to raise_error(ArgumentError)
    end

    it "deletes a data store zone" do
      @data_store_zone.delete(1)
      @data_store_zone.success.should be_true
    end
  end

end