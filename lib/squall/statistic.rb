module Squall
  # OnApp Statistic
  class Statistic < Base
    # Returns statitics for virtual machines
    def daily_stats
      response = request(:get, "/usage_statistics.json")
      response.collect {|s| s["vm_stat"]}
    end
  end
end
