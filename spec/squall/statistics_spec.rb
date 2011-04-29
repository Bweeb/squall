require 'spec_helper'

describe Squall::VirtualMachine do
  before(:each) do
    default_config
    @statistics = Squall::Statistics.new
  end

  describe "#usage_statistics" do
    use_vcr_cassette "statistics/usage_statistics"

    it "requires an id" do
      expect { @statistics.daily_stats }.to raise_error(ArgumentError)
      @statistics.success.should be_false
    end

    it "returns the daily statistics" do
      result = @statistics.daily_stats(1)
      result['id'].to_i.should == 1
      result['cost'].to_f.should == 0.0
    end
  end
end
