require 'spec_helper'

describe Squall::Config do
  before(:each) do
    @config = Squall::Config.new
  end

  describe "#new" do
    it "sets up the @config hash" do
      @config.config.should == {}
    end
  end

  describe "#[]" do
    it "behaves like an array" do
      @config.config[:something] = 1
      @config[:something].should == 1
    end
  end

  describe "#base_uri" do
    it "sets the base_uri" do
      @config.config[:base_uri].should be_nil
      @config.base_uri 'url'
      @config.config[:base_uri].should == 'url'     
    end
  end

  describe "#username" do
    it "sets the username" do
      @config.config[:username].should be_nil     
      @config.username 'user'
      @config.config[:username].should == 'user'      
    end
  end

  describe "#password" do
    it "sets the password" do
      @config.config[:password].should be_nil           
      @config.password 'pass'
      @config.config[:password].should == 'pass'
    end
  end
end