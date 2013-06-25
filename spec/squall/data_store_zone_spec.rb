require 'spec_helper'

describe Squall::DataStoreZone do
  before(:each) do
    @data_store_zone = Squall::DataStoreZone.new
    @valid = {label: "My zone"}
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

    it "returns a data store zone" do
      data_store_zone = @data_store_zone.show(1)
      data_store_zone.should be_a(Hash)
    end
  end

  describe "#create" do
    use_vcr_cassette "data_store_zone/create"

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

    it "edits a data store zone" do
      @data_store_zone.edit(1, label: "Updated zone")
      @data_store_zone.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette "data_store_zone/delete"

    it "deletes a data store zone" do
      @data_store_zone.delete(1)
      @data_store_zone.success.should be_true
    end
  end

end