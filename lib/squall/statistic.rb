module Squall
  # OnApp Statistic
  class Statistic < Base
    # Public: Get usage statistics for virtual machines.
    #
    # Returns an Array.
    def daily_stats
      response = request(:get, "/usage_statistics.json")
      response.collect {|s| s["vm_stat"]}
    end
  end
end
