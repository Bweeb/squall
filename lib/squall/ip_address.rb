module Squall
  # OnApp IpAddress
  class IpAddress < Base
    # Returns a list of IpAddresses
    #
    # ==== Options
    # * +network_id+ - required
    def list(network_id)
      response = request(:get, "/settings/networks/#{network_id}/ip_addresses.json")
      response.collect { |ip| ip['ip_address'] }
    end
  end
end
