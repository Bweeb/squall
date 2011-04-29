module Squall
  class Statistics < Base
    def daily_stats(id)
      response = request(:get, "/usage_statistics.json")
      response.first['vm_hourly_stat']
    end
  end
end
