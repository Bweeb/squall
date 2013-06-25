module Squall
  # OnApp IpAddress
  class IpAddress < Base
    # Public: Lists IP addresses for a network.
    #
    # network_id - ID of the network
    #
    # Returns an Array.
    def list(network_id)
      response = request(:get, "/settings/networks/#{network_id}/ip_addresses.json")
      response.collect { |ip| ip['ip_address'] }
    end

    # Public: Creates a new IpAddress
    #
    # network_id - ID of the network
    # options    - Params for the new ip address
    #              :address            - IP address
    #              :broadcast          - A logical address at which all devices
    #                                    connected to a multiple-access
    #                                    communications network are enabled to
    #                                    receive datagrams
    #              :disallowed_primary - Set to '1' to prevent this address
    #                                    being used as primary
    #              :gateway            - Gateway address
    #              :netmask            - Network mask
    #              :network_address    - IP address of network
    #
    # Returns a Hash.
    def create(network_id, options = {})
      request(:post, "/settings/networks/#{network_id}/ip_addresses.json", default_params(options))
    end

    # Public: Updates an existing ip address.
    #
    # network_id - ID of the network
    # id         - ID of the ip address
    # options     - Params for updating the ip address, see `#create`
    #
    # Returns a Hash.
    def edit(network_id, id, options = {})
      request(:put, "/settings/networks/#{network_id}/ip_addresses/#{id}.json", default_params(options))
    end

    # Public: Deletes an existing ip address.
    #
    # network_id - ID of the network
    # id         - ID of the ip address
    #
    # Returns a Hash.
    def delete(network_id, id)
      request(:delete, "/settings/networks/#{network_id}/ip_addresses/#{id}.json")
    end
  end
end
