require 'spec_helper'

describe "Squall::CLI.group :virtual_machine" do
  it { Squall::CLI.groups.assoc(:virtual_machine).should_not be_nil }
end
