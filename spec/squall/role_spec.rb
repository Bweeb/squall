require 'spec_helper'

describe Squall::Role do
  before(:each) do
    @role = Squall::Role.new
    @keys = ["label", "created_at", "updated_at", "id", "permissions", "identifier"]
  end

  describe "#list" do
    use_vcr_cassette "role/list"
    it "returns roles" do
      roles = @role.list
      roles.all?{|r| r.first == "role"}
    end
  end

  describe "#show" do
    use_vcr_cassette "role/show"
    it "requires an id" do
      expect { @role.show }.to raise_error(ArgumentError)
    end

    it "returns 404 for invalid id" do
      expect { @role.show(404) }.to raise_error(Squall::NotFound)
    end

    it "returns a role" do
      role = @role.show(1)
      role.keys.should include(*@keys)
    end
  end

  describe "#edit" do
    use_vcr_cassette "role/edit"
    it "requires an id" do
      expect { @role.edit }.to raise_error(ArgumentError)
    end

    it "returns 404 for invalid id" do
      expect { @role.edit(404) }.to raise_error(Squall::NotFound)
    end

    it "allows all optional params" do
      optional = [:label, :permission_ids]
      optional.each do |k|
        opts = @role.default_params(k.to_sym => 1)
        args = [:put, '/roles/1.json', opts]
        @role.should_receive(:request).with(*args).once.and_return([])
        @role.edit(1, k.to_sym => 1 )
      end
    end

    it "updates the role" do
      pending "OnApp is returning an empty response" do
        role = @role.edit(1, :label => 'New')
        role['label'].should == 'New'
      end
    end
  end

  describe "#delete" do
    use_vcr_cassette "role/delete"
    it "requires an id" do
      expect { @role.delete }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid user" do
      expect { @role.delete(5) }.to raise_error(Squall::NotFound)
    end

    it "returns a role" do
      role = @role.delete(3)
      @role.success.should be_true
    end
  end

  describe "#permissions" do
    use_vcr_cassette "role/permissions"
    it "returns permissions" do
      permissions = @role.permissions
      permissions.size.should be(229)

      keys = ["label", "created_at", "updated_at", "id", "identifier"]
      first = permissions.first
      first.keys.should include(*keys)

      keys.each do |key| 
        first[key].should_not be_nil
        first[key].to_s.size.should be >= 1
      end
    end
  end

  describe "#create" do
    use_vcr_cassette "role/create"
    it "requires login" do
      requires_attr(:label) { @role.create }
    end

    it "requires label" do
      requires_attr(:identifier) { @role.create(:label => 'my-label') }
    end

    it "raises error on duplicate" do
      expect { 
        @role.create(:label => 'Test', :identifier => 'testing')
      }.to raise_error(Squall::RequestError)
      @role.errors['identifier'].should include("has already been taken")
    end

    it "creates a role" do
      value = {:label => 'Test Create', :identifier => 'testing-create'}
      role = @role.create(value)
      role['label'].should  == value[:label]
      role['identifier'].should == value[:identifier]
    end
  end
end
