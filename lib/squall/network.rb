module Squall
  # OnApp Network
  class Network < Base
    # Public: Lists all networks.
    #
    # Returns an Array.
    def list
      response = request(:get, '/settings/networks.json')
      response.collect { |network| network['network'] }
    end

    # Public: Create a Network.
    #
    # options - Params for creating the Network:
    #           :label
    #           :vlan
    #           :identifier
    #
    # Example
    #
    #   create(
    #     label:            'mynetwork',
    #     network_group_id: 1,
    #     vlan:             2,
    #     identifier:       'something'
    #   )
    #
    # Returns a Hash.
    def create(options = {})
      response = request(:post, '/settings/networks.json', default_params(options))
      response.first[1]
    end

    # Public: Edit a Network
    #
    # id      - ID of the network
    # options - Params for editing the Network, see `#create`
    #
    # Returns a Hash.
    def edit(id, options = {})
      request(:put, "/settings/networks/#{id}.json", default_params(options))
    end

    # Public: Delete a network.
    #
    # id - ID of the network
    #
    # Returns a Hash.
    def delete(id)
      request(:delete, "/settings/networks/#{id}.json")
    end

    # Public: Rebuild VM network.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def rebuild(id)
      request(:post, "/virtual_machines/#{id}/rebuild_network.json")
    end
  end
end
