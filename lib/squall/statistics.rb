module Squall
  class Statistics < Base
    def daily_stats(id, options = {})
      response = request(:get, "/usage_statistics.json", :query => options)
      response.first['vm_hourly_stat']
    end
  end
end
