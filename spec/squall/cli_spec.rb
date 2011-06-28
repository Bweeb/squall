require 'spec_helper'
# module Kernel
#   def puts(*arg); end
# end

describe Squall::CLI do
  before :each do
    @cli = Squall::CLI.new(%w[delorean time_travel 1955])
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

  describe "#help" do
    it { @cli.help.should match /Command list:/ }
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

describe "./bin/squall virtual_machine" do
  it "returns help with no arguments" do
    cli = Squall::CLI.new(%w[virtual_machine])
    cli.parser.to_s.should match /Usage: squall virtual_machine/
  end
end
