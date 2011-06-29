require 'spec_helper'

describe Squall::CLI::Command do
  before :each do
    @cmd = Squall::CLI::Command.new(:test_command)
  end

  it { @cmd.should have_attr_reader :required_params }
  it { @cmd.should have_attr_reader :optional_params }

  describe "#initialize" do
    it "sets @name" do
      @cmd.instance_variable_get(:@name).should == :test_command
    end

    %w[required_params optional_params].each do |key|
      it "sets @#{key} to empty Array" do
        @cmd.instance_variable_get("@#{key}").should == []
      end
    end

    it "sets @options to an empty Hash" do
      @cmd.instance_variable_get(:@options).should == {}
    end
  end

  describe "#description" do
    it "sets @description with an argument" do
      desc = "My Cool Prog"
      @cmd.description desc
      @cmd.instance_variable_get(:@description).should == desc
    end

    it "gets @description with no arguement" do
      desc = "My Cooler Prog"
      @cmd.instance_variable_set(:@description, desc)
      @cmd.description.should == desc
    end
  end

  describe "#build_parser" do
    # parser = OptionParser.new
  end
end
