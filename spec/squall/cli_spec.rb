require 'spec_helper'

describe Squall::CLI do
  before :each do
    @cli = Squall::CLI.new(%w[delorean time_travel 1955])
  end

  describe "::groups" do
    it { @cli.class.groups.should be_an Array }
  end

  describe "#initialize" do
    it "sets @command" do
      @cli.instance_variable_get(:@command).should == 'delorean'
    end

    it "sets @subcommand" do
      @cli.instance_variable_get(:@subcommand).should == 'time_travel'
    end

    it "sets @parser" do
      @cli.instance_variable_get(:@parser).should be_a OptionParser
    end

    it "sets @parser.program_name" do
      @cli.parser.program_name.should match /delorean time_travel/
    end

    it "sets @argv" do
      argv = @cli.instance_variable_get(:@argv)
      argv.should have(1).item
      argv.first.should == '1955'
    end
  end

  describe "#dispatch!" do
    it "exits with invalid command" do
      @cli.stub(:puts)
      @cli.should_receive(:exit).with(-1)
      @cli.dispatch!
    end
  end

  describe "#print_help_if_argv_empty" do
    it "appends --help to @argv" do
      cli = Squall::CLI.new
      cli.print_help_if_argv_empty
      argv = cli.instance_variable_get(:@argv)
      argv.should have(1).item
      argv.first.should == '--help'
    end
  end

end
