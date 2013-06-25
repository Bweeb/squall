require 'spec_helper'

describe Squall::Role do
  before(:each) do
    @role = Squall::Role.new
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

    it "returns a role" do
      role = @role.show(1)
      role.should be_a(Hash)
    end
  end

  describe "#edit" do
    use_vcr_cassette "role/edit"

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
        role = @role.edit(1, label: 'New')
        role['label'].should == 'New'
      end
    end
  end

  describe "#delete" do
    use_vcr_cassette "role/delete"

    it "returns a role" do
      role = @role.delete(3)
      @role.success.should be_true
    end
  end

  describe "#permissions" do
    use_vcr_cassette "role/permissions"

    it "returns permissions" do
      permissions = @role.permissions
      permissions.should be_an(Array)
    end

    it "contains role data" do
      permissions = @role.permissions
      permissions.all?.should be_true
    end

  end

  describe "#create" do
    use_vcr_cassette "role/create"

    it "allows permission_ids" do
      @role.should_receive(:request).once.and_return Hash.new('role' => [])
      @role.create(label: "test", permission_ids: 1)
    end

    it "creates a role" do
      response = @role.create({label: 'Test Create', permission_ids: 1})
      response["role"]['label'].should  == 'Test Create'
      response["role"]['permissions'].should_not be_empty
    end
  end
end
