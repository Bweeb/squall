require 'spec_helper'

describe Squall::Statistic do
  before(:each) do
    @statistic = Squall::Statistic.new
  end

  describe "#usage_statistic" do
    use_vcr_cassette "statistic/usage_statistics"

    it "returns the daily statistics" do
      result = @statistic.daily_stats
      result.should be_an(Array)
    end
    
    it "contains the statistic data" do
      result = @statistic.daily_stats
      result.all?.should be_true
    end
  end
end
