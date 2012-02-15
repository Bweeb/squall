module Squall
  # OnApp IpAddress
  class IpAddress < Base
    # Returns a list of ip addresses for a network
    #
    # ==== Params
    #
    # * +network_id+ - ID of the network
    def list(network_id)
      response = request(:get, "/settings/networks/#{network_id}/ip_addresses.json")
      response.collect { |ip| ip['ip_address'] }
    end

    # Updates an existing ip address
    #
    # ==== Params
    #
    # * +network_id+ - ID of the network
    # * +id+ - ID of the ip address
    # * +options+ - Params for updating the ip address
    #
    # ==== Options
    #
    # See #create
    def edit(network_id, id, options = {})
      params.accepts(:address, :netmask, :broadcast, :network_address, :gateway, :disallowed_primary).validate!(options)
      response = request(:put, "/settings/networks/#{network_id}/ip_addresses/#{id}.json", default_params(options))
    end

    # Creates a new IpAddress
    #
    # ==== Params
    #
    # * +network_id+ - ID of the network
    # * +options+ - Params for the new ip address
    #
    # ==== Options
    #
    # * +address*+ - IP address
    # * +netmask*+ - Network mask
    # * +broadcast*+ - A logical address at which all devices connected to a multiple-access communications network are enabled to receive datagrams
    # * +network_address*+ - IP address of network
    # * +gateway*+ - Gateway address
    # * +disallowed_primary+ - Set to '1' to prevent this address being used as primary
    def create(network_id, options = {})
      params.required(:address, :netmask, :broadcast, :network_address, :gateway).accepts(:disallowed_primary).validate!(options)
      response = request(:post, "/settings/networks/#{network_id}/ip_addresses.json", default_params(options))
    end

    # Deletes an existing ip address
    #
    # ==== Params
    #
    # * +network_id+ - ID of the network
    # * +id+ - ID of the ip address
    def delete(network_id, id)
      request(:delete, "/settings/networks/#{network_id}/ip_addresses/#{id}.json")
    end
  end
end
