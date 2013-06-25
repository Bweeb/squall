module Squall
  # OnApp Hypervisor
  class Hypervisor < Base
    # Public: Lists all hypervisors.
    #
    # Returns an Array.
    def list
      req = request(:get, '/settings/hypervisors.json')
      req.collect { |hv| hv['hypervisor'] }
    end

    # Public: Retrieves hypervisor info.
    #
    # id - The id of the hypervisor
    #
    # Returns a Hash.
    def show(id)
      req = request(:get, "/settings/hypervisors/#{id}.json")
      req.first[1]
    end

    # Public: Create a new Hypervisor.
    #
    # options - Options for creating the hypervisor:
    #           :label           - Label for the hypervisor
    #           :ip_address      - IP for the hypervisor
    #           :hypervisor_type - Type of the hypervisor
    #
    # Example
    #
    #     create(
    #       label:           'myhv',
    #       ip_address:      '127.0.0.1',
    #       hypervisor_type: 'xen'
    #     )
    #
    # Returns a Hash.
    def create(options = {})
      req = request(:post, '/settings/hypervisors.json', default_params(options))
      req.first[1]
    end

    # Public: Edit a Hypervisor.
    #
    # id      - ID of the hypervisor
    # options - Params for editing the Hypervisor, see `#create`.
    #
    # Example
    #
    #     edit 1, label: 'myhv', ip_address: '127.0.0.1'
    #
    # Returns a Hash.
    def edit(id, options = {})
      request(:put, "/settings/hypervisors/#{id}.json", default_params(options))
    end

    # Public: Reboot a hypervisor.
    #
    # id - ID of the hypervisor
    #
    # Returns a Hash.
    def reboot(id)
      response = request(:get, "/settings/hypervisors/#{id}/rebooting.json")
      response['hypervisor']
    end

    # Public: Delete a hypervisor
    #
    # id - ID of the hypervisor
    #
    # Returns a Hash.
    def delete(id)
      req = request(:delete, "/settings/hypervisors/#{id}.json")
    end

    # TODO: Add documentation
    def virtual_machines(id)
      response = request(:get, "/settings/hypervisors/#{id}/virtual_machines.json")
      response.collect { |vm| vm['virtual_machine'] }
    end

    # TODO: Add documentation
    def data_store_joins(id)
      response = request(:get, "/settings/hypervisors/#{id}/data_store_joins.json")
      response.collect { |dsj| dsj['data_store_join'] }
    end

    # TODO: Add documentation
    def add_data_store_join(id, data_store_id)
      request(:post, "/settings/hypervisors/#{id}/data_store_joins.json", query: { data_store_id:  data_store_id })
    end

    # TODO: Add documentation
    def remove_data_store_join(id, data_store_join_id)
      request(:delete, "/settings/hypervisors/#{id}/data_store_joins/#{data_store_join_id}.json")
    end

    # TODO: Add documentation
    def network_joins(id)
      response = request(:get, "/settings/hypervisors/#{id}/network_joins.json")
      response.collect { |nj| nj['network_join'] }
    end

    # TODO: Add documentation
    def add_network_join(id, options)
      request(:post, "/settings/hypervisors/#{id}/network_joins.json", query: { network_join: options })
    end

    # TODO: Add documentation
    def remove_network_join(id, network_join_id)
      request(:delete, "/settings/hypervisors/#{id}/network_joins/#{network_join_id}.json")
    end
  end
end
