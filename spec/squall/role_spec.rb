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
      optional.each do |param|
        args = [:put, '/roles/1.json', @role.default_params(param => 1)]
        @role.should_receive(:request).with(*args).once.and_return([])
        @role.edit(1, param => 1 )
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
      permissions.size.should == 369

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

    it "requires label" do
      requires_attr(:label) { @role.create }
    end
    
    it "allows permission_ids" do
      @role.should_receive(:request).once.and_return Hash.new('role' => [])
      @role.create(:label => "test", :permission_ids => 1)
    end

    it "creates a role" do
      response = @role.create({:label => 'Test Create', :permission_ids => 1})
      response["role"]['label'].should  == 'Test Create'
      response["role"]['permissions'].should_not be_empty
    end
  end
end
