module Squall
  # OnApp HypervisorZone
  class HypervisorZone < Base
    # Public: Lists all hypervisor zones.
    #
    # Returns an Array.
    def list
      response = request(:get, "/settings/hypervisor_zones.json")
      response.collect { |i| i['hypervisor_group'] }
    end

    # Public: Get the details for a hypervisor zone.
    #
    # id - ID of the hypervisor zone
    #
    # Returns a Hash.
    def show(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}.json")
      response['hypervisor_group']
    end

    # Public: Creates a new hypervisor zone.
    #
    # options - Params for updating the hypervisor zone:
    #           :label - Label for the hypervisor zone
    #
    # Returns a Hash
    def create(options = {})
      request(:post, "/settings/hypervisor_zones.json", query: { pack: options })
    end

    # Public: Updates an existing hypervisor zone.
    #
    # id      - ID of the hypervisor zone
    # options - Params for updating the hypervisor zone, see `#create`
    #
    # Returns a Hash.
    def edit(id, options = {})
      request(:put, "/settings/hypervisor_zones/#{id}.json", query:  { pack: options })
    end

    # Public: Deletes an existing hypervisor zone.
    #
    # id - ID of the hypervisor zone
    #
    # Returns a Hash.
    def delete(id)
      request(:delete, "/settings/hypervisor_zones/#{id}.json")
    end

    # Public: List hypervisors attached to a zone.
    #
    # id - ID of the hypervisor zone
    #
    # Returns an Array.
    def hypervisors(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}/hypervisors.json")
      response.collect { |hv| hv['hypervisor'] }
    end

    # Public: List data store joins attached to a hypervisor zone.
    #
    # id - ID of the hypervisor zone
    #
    # Returns an Array.
    def data_store_joins(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}/data_store_joins.json")
      response.collect { |i| i['data_store_join'] }
    end

    # Public: Add a data store to a hypervisor zone.
    #
    # id            - ID of the hypervisor zone
    # data_store_id - ID of the data store
    #
    # Returns a Hash.
    def add_data_store_join(id, data_store_id)
      request(:post, "/settings/hypervisor_zones/#{id}/data_store_joins.json", query: { data_store_id: data_store_id })
    end

    # Public: Remove a data store from a hypervisor zone.
    #
    # id                 - ID of the hypervisor zone
    # data_store_join_id - ID of the join record
    #
    # Returns a Hash.
    def remove_data_store_join(id, data_store_join_id)
      request(:delete, "/settings/hypervisor_zones/#{id}/data_store_joins/#{data_store_join_id}.json")
    end

    # Public: List networks attached to a hypervisor zone.
    #
    # id - ID of the hypervisor zone
    #
    # Returns an Array.
    def network_joins(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}/network_joins.json")
      response.collect { |i| i['network_join'] }
    end

    # Public: Add a network to a hypervisor zone
    #
    # id      - ID of the hypervisor zone
    # options - Params for updating the hypervisor zone
    #           :network_id - ID of the network to add to the hypervisor zone
    #           :interface  - Name of the appropriate network interface
    #
    # Returns a Hash.
    def add_network_join(id, options = {})
      request(:post, "/settings/hypervisor_zones/#{id}/network_joins.json", query: { network_join:  options })
    end

    # Public: Remove a network from a hypervisor zone.
    #
    # id              - ID of the hypervisor zone
    # network_join_id - ID of the join record
    #
    # Returns a Hash.
    def remove_network_join(id, network_join_id)
      request(:delete, "/settings/hypervisor_zones/#{id}/network_joins/#{network_join_id}.json")
    end
  end
end
