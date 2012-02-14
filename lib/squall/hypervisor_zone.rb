module Squall
  # OnApp HypervisorZone
  class HypervisorZone < Base
    # Returns a list of hypervisor zones
    def list
      response = request(:get, "/settings/hypervisor_zones.json")
      response.collect { |i| i['hypervisor_group'] }
    end
    
    # Get the details for a hypervisor zone
    def show(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}.json")
      response['hypervisor_group']
    end

    # Updates an existing hypervisor zone
    #
    # ==== Options
    # * +options+ - Params for updating the hypervisor zone
    def edit(id, options = {})
      params.required(:label).validate!(options)
      response = request(:put, "/settings/hypervisor_zones/#{id}.json", :query => {:pack => options})
    end

    # Creates a new NetworkZone
    #
    # ==== Options
    # * +options+ - Params for the new hypervisor zone
    def create(options = {})
      params.required(:label).validate!(options)
      response = request(:post, "/settings/hypervisor_zones.json", :query => {:pack => options})
    end

    # Deletes an existing hypervisor zone
    #
    # ==== Options
    # * +id+ - required
    def delete(id)
      request(:delete, "/settings/hypervisor_zones/#{id}.json")
    end
    
    # Get the list of hypervisors attached to a zone
    def hypervisors(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}/hypervisors.json")
      response.collect { |hv| hv['hypervisor'] }
    end
    
    # Get the list of data store joins attached to a hypervisor zone
    def data_store_joins(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}/data_store_joins.json")
      response.collect { |i| i['data_store_join'] }
    end
    
    # Add a data store to a hypervisor zone
    def add_data_store_join(id, data_store_id)
      request(:post, "/settings/hypervisor_zones/#{id}/data_store_joins.json", :query => {:data_store_id => data_store_id})
    end
    
    # Remove a data store from a hypervisor zone
    def remove_data_store_join(id, data_store_join_id)
      request(:delete, "/settings/hypervisor_zones/#{id}/data_store_joins/#{data_store_join_id}.json")
    end
    
    # Get the list of networks attached to a hypervisor zone
    def network_joins(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}/network_joins.json")
      response.collect { |i| i['network_join'] }
    end
    
    # Add a network to a hypervisor zone
    #
    # ==== Options
    # * +network_id+ - The ID of the network to add to the hypervisor zone
    # * +interface+ - The name of the appropriate network interface
    def add_network_join(id, options={})
      params.required(:network_id, :interface).validate!(options)
      request(:post, "/settings/hypervisor_zones/#{id}/network_joins.json", :query => {:network_join => options})
    end
    
    # Remove a network from a hypervisor zone
    def remove_network_join(id, network_join_id)
      request(:delete, "/settings/hypervisor_zones/#{id}/network_joins/#{network_join_id}.json")
    end
    
  end
end
