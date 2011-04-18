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

    it "returns not found for invalid user" do
      expect { @role.show(5) }.to raise_error(Squall::NotFound)
    end

    it "returns a role" do
      role = @role.show(1)
      role.keys.should include(*@keys)
      role['label'].should == "Administrator"
    end
  end

  describe "#edit" do
    use_vcr_cassette "role/edit"
    it "requires an id" do
      expect { @role.edit }.to raise_error(ArgumentError)
    end

    it "returns not found for invalid user" do
      expect { @role.edit(5) }.to raise_error(Squall::NotFound)
    end

    it "updates the role" do
      pending "OnApp is returning an empty response" do
        old_role = @role.show(3)
        old_role['label'].should == "Other"

        new_role = @role.edit(3, :label => 'New')
        new_role['label'].should == 'New'
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
