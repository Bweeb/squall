require 'spec_helper'

describe Squall do
  describe "VERSION" do
    it "has a valid format" do
      Squall::VERSION.should match /\d+/
    end
  end

  describe "#config" do
    it "yields a configuration with a block" do
      Squall.should_receive(:config).and_yield(Squall::Config.new)
      Squall.config { |c| c }
    end

    it "returns the config after yield" do
      Squall.config { |c| c }.should == {}
      Squall.config.should == {}
    end


    it "returns the config without a block" do
      Squall.config.should == {}
    end

    it "sets the base URI" do
      Squall.config { |c| c.base_uri 'hi'}
      Squall.config.should_not be_empty
      Squall.config[:base_uri] == 'hi'
    end
  end

  describe "#reset" do
    it "resets the configuration to defaults" do
      default_config
      Squall.config.should_not be_empty
      Squall.reset_config
      Squall.config.should be_empty
    end
  end
end
