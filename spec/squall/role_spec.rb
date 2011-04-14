require 'spec_helper'

describe Squall::Role do
  before(:each) do
    default_config
    @role = Squall::Role.new
    @keys = ["label", "created_at", "updated_at", "id", "permissions", "identifier"]
  end

  describe "#list" do
    use_vcr_cassette "role/list"
    it "returns roles" do
      roles = @role.list
      roles.size.should be(2)
    end

    it "contains the role of a user" do
      role = @role.list.first
      role.keys.should include(*@keys)
      role['label'].should == "Administrator"
    end
  end

  describe "#show" do
    use_vcr_cassette "role/show"
    it "requires an id" do
      expect { @role.show }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid roles" do
      expect { @role.show(5) }.to raise_error(Squall::NotFound)
    end

    it "returns a role" do
      role = @role.show(1)
      role.keys.should include(*@keys)
      role['label'].should == "Administrator"
    end
  end
end