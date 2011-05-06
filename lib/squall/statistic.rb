module Squall
  # OnApp Statistic
  class Statistic < Base
    # Returns statitics for a given VirtualMachine
    def daily_stats(id)
      response = request(:get, "/usage_statistics.json")
      response.first['vm_hourly_stat']
    end
  end
end
