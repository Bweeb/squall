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
      Squall.reset_config
      Squall.config { |c| c }.should == {}
      Squall.config.should == {}
    end


    it "returns the config without a block" do
      Squall.reset_config
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
      Squall.config.should_not be_empty
      Squall.reset_config
      Squall.config.should be_empty
    end
  end

  describe "#config_file" do
    it "defaults to ~/.squall" do
      File.stub(:exists?).and_return(true)
      YAML.stub(:load_file).and_return({})
      Squall.config_file
      Squall.configuration_file.should == "#{ENV['HOME']}/.squall.yml"
    end

    it "returns an error if the file doesn't exist" do
      expect { Squall.config_file '/tmp/missing.yml'}.to raise_error(ArgumentError, "Config file doesn't exist '/tmp/missing.yml'")
    end

    it "loads the yaml" do
      File.stub(:exists?).and_return(true)
      config = {'username' => 'test', 'password' => 'pass', 'base_uri' => 'http://example.com'}
      YAML.should_receive(:load_file).with('/tmp/exists.yml').and_return(config)
      Squall.config_file '/tmp/exists.yml'
      Squall.config.should include(username: config['username'], password: config['password'], base_uri: config['base_uri'])
    end
  end
end
