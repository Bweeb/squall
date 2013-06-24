require 'spec_helper'

describe Squall::UserGroup do
  before(:each) do
    @keys = ["amount"]
    @user_group = Squall::UserGroup.new
    @valid = {label: "My new group"}
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

    it "creates a user group" do
      @user_group.create(@valid)
      @user_group.success.should be_true
    end
  end

  describe "#edit" do
    use_vcr_cassette "user_group/edit"

    it "edits a user group" do
      @user_group.edit(1, @valid)
      @user_group.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette "user_group/delete"

    it "deletes a user group" do
      @user_group.delete(1)
      @user_group.success.should be_true
    end
  end
end