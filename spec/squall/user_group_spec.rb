require 'spec_helper'

describe Squall::UserGroup do
  before(:each) do
    @keys = ["amount"]
    @user_group = Squall::UserGroup.new
    @valid = {:label => "My new group"}
  end

  describe "#list" do
    use_vcr_cassette "user_group/list"
    
    it "returns a list of user groups" do
      user_groups = @user_group.list
      user_groups.should be_an(Array)
    end

    it "contains first user group's data" do
      user_group = @user_group.list.first
      user_group.should be_a(Hash)
    end
  end
  
  describe "#create" do
    use_vcr_cassette "user_group/create"
    it "requires label" do
      invalid = @valid.reject{|k,v| k == :label }
      requires_attr(:label) { @user_group.create(invalid) }
    end
    
    it "raises error on unknown params" do
      expect { @user_group.create(@valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "creates a user group" do
      @user_group.create(@valid)
      @user_group.success.should be_true
    end
  end
  
  describe "#edit" do
    use_vcr_cassette "user_group/edit"
    
    it "raises error on unknown params" do
      expect { @user_group.edit(1, :what => 'what') }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "edits a user group" do
      @user_group.edit(1, @valid)
      @user_group.success.should be_true
    end
    
    it "raises an error for an invalid user group id" do
      expect { @user_group.edit(404, @valid) }.to raise_error(OnApp::NotFoundError)
    end
  end
  
  describe "#delete" do
    use_vcr_cassette "user_group/delete"
    it "requires an id" do
      expect { @user_group.delete }.to raise_error(ArgumentError)
    end

    it "deletes a user group" do
      @user_group.delete(1)
      @user_group.success.should be_true
    end

    it "returns NotFound for missing user" do
      expect { @user_group.delete(404) }.to raise_error(OnApp::NotFoundError)
    end
  end

end