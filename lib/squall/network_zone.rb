module Squall
  # OnApp NetworkZone
  class NetworkZone < Base
    # Returns a list of network zones
    def list
      response = request(:get, "/network_zones.json")
      response.collect { |i| i['network_group'] }
    end

    # Get the details for a network zone
    #
    # ==== Params
    #
    # * +id*+ - ID of the network zone
    def show(id)
      response = request(:get, "/network_zones/#{id}.json")
      response['network_group']
    end

    # Updates an existing network zone
    #
    # ==== Params
    #
    # * +id*+ - ID of the network zone
    #
    # ==== Options
    #
    # See #create
    def edit(id, options = {})
      request(:put, "/network_zones/#{id}.json", query:  { pack: options })
    end

    # Creates a new network zone
    #
    # ==== Options
    #
    # * +label*+ - Label for the network zone
    def create(options = {})
      request(:post, "/network_zones.json", query: { pack: options })
    end

    # Deletes an existing network zone
    #
    # ==== Params
    #
    # * +id*+ - ID of the network zone
    def delete(id)
      request(:delete, "/network_zones/#{id}.json")
    end

    # Attach a network to a network zone
    #
    # ==== Params
    #
    # * +id*+ - ID of the network zone
    # * +network_id+ - ID of the network
    def attach(id, network_id)
      request(:post, "/network_zones/#{id}/networks/#{network_id}/attach.json")
    end

    # Detach a network from a network zone
    #
    # ==== Params
    #
    # * +id*+ - ID of the network zone
    # * +network_id+ - ID of the network
    def detach(id, network_id)
      request(:post, "/network_zones/#{id}/networks/#{network_id}/detach.json")
    end
  end
end
