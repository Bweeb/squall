require 'spec_helper'

describe Squall::Statistic do
  before(:each) do
    @statistic = Squall::Statistic.new
  end

  describe "#usage_statistic" do
    use_vcr_cassette "statistic/usage_statistics"

    it "requires an id" do
      expect { @statistic.daily_stats }.to raise_error(ArgumentError)
      @statistic.success.should be_false
    end

    it "returns the daily statistics" do
      result = @statistic.daily_stats(1)
      result['id'].to_i.should == 1
      result['cost'].to_f.should == 0.0
    end
  end
end
