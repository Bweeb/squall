require 'spec_helper'

describe Squall::Whitelist do
  before(:each) do
    @keys = ["ip", "description"]
    @whitelist = Squall::Whitelist.new
    @valid = {:ip => "192.168.1.1"}
  end

  describe "#list" do
    use_vcr_cassette "whitelist/list"
    
    it "requires user id" do
      expect { @whitelist.list }.to raise_error(ArgumentError)
    end
    
    it "returns a user's whitelists" do
      whitelists = @whitelist.list(1)
      whitelists.should be_an(Array)
    end

    it "contains the whitelists data" do
      whitelists = @whitelist.list(1)
      whitelists.all? {|w| w.is_a?(Hash) }.should be_true
    end
  end
  
  describe "#show" do
    use_vcr_cassette "whitelist/show"
    it "requires an id" do
      expect { @whitelist.show(1) }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid whitelists" do
      expect { @whitelist.show(1, 404) }.to raise_error(Squall::NotFound)
    end

    it "returns a whitelist" do
      whitelist = @whitelist.show(1, 2)
      whitelist.should be_a(Hash)
    end
  end
  
  describe "#create" do
    use_vcr_cassette "whitelist/create"
    it "requires amount" do
      invalid = @valid.reject{|k,v| k == :ip }
      requires_attr(:ip) { @whitelist.create(1, invalid) }
    end
    
    it "allows all optional params" do
      optional = [:description]
      @whitelist.should_receive(:request).exactly(optional.size).times.and_return Hash.new("whitelist" => {})
      optional.each do |param|
        @whitelist.create(1, @valid.merge(param => "test"))
      end
    end
    
    it "raises error on unknown params" do
      expect { @whitelist.create(1, @valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end
    
    it "raises an error for an invalid user id" do
      expect { @whitelist.create(404, @valid) }.to raise_error(Squall::NotFound)
    end

    it "creates a whitelist for a user" do
      @whitelist.create(1, @valid)
      @whitelist.success.should be_true
    end
  end
  
  describe "#edit" do
    use_vcr_cassette "whitelist/edit"
    
    it "allows select params" do
      optional = [:ip, :description]
      @whitelist.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @whitelist.edit(1, 1, param => "test")
      end
    end
    
    it "raises error on unknown params" do
      expect { @whitelist.edit(1, 1, :what => 'what') }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "edits a whitelist" do
      @whitelist.edit(1, 1, :description => "This is actually a different computer.")
      @whitelist.success.should be_true
    end
    
    it "raises an error for an invalid whitelist id" do
      expect { @whitelist.edit(1, 404, @valid) }.to raise_error(Squall::NotFound)
    end
  end
  
  describe "#delete" do
    use_vcr_cassette "whitelist/delete"
    it "requires an id" do
      expect { @whitelist.delete }.to raise_error(ArgumentError)
    end

    it "deletes a whitelist" do
      @whitelist.delete(1, 1)
      @whitelist.success.should be_true
    end

    it "returns NotFound for missing user" do
      expect { @whitelist.delete(1, 404) }.to raise_error(Squall::NotFound)
    end
  end

end