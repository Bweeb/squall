module Squall
  # OnApp Hypervisor
  class Hypervisor < Base

    # Returns a list of all hypervisors
    def list
      req = request(:get, '/settings/hypervisors.json')
      req.collect { |hv| hv['hypervisor'] }
    end

    # Returns the hypervisor info as a hash
    #
    # ==== Params
    #
    # * +id+ - The id of the hypervisor
    def show(id)
      req = request(:get, "/settings/hypervisors/#{id}.json")
      req.first[1]
    end

    # Create a new Hypervisor
    #
    # ==== Params
    #
    # * +options+ - Options for creating the hypervisor
    #
    # ==== Options
    #
    # * +label*+ - Label for the hypervisor
    # * +ip_address*+ - IP for the hypervisor
    # * +hypervisor_type*+ - Type of the hypervisor
    #
    # ==== Example
    #
    #   create :label => 'myhv', :ip_address => '127.0.0.1', :hypervisor_type => 'xen'
    def create(options = {})
      req = request(:post, '/settings/hypervisors.json', default_params(options))
      req.first[1]
    end

    # Edit a Hypervisor
    #
    # ==== Params
    #
    # * +id*+ - ID of the hypervisor
    # * +options+ - Params for editing the Hypervisor
    #
    # ==== Options
    #
    # See #create
    #
    # ==== Example
    #
    #   edit 1, :label => 'myhv', :ip_address => '127.0.0.1'
    def edit(id, options ={})
      request(:put, "/settings/hypervisors/#{id}.json", default_params(options))
    end

    # Reboot a hypervisor
    #
    # ==== Params
    #
    # * +id*+ - ID of the hypervisor
    def reboot(id)
      response = request(:get, "/settings/hypervisors/#{id}/rebooting.json")
      response['hypervisor']
    end

    # Delete a hypervisor
    #
    # ==== Params
    #
    # * +id*+ - ID of the hypervisor
    def delete(id)
      req = request(:delete, "/settings/hypervisors/#{id}.json")
    end

    def virtual_machines(id)
      response = request(:get, "/settings/hypervisors/#{id}/virtual_machines.json")
      response.collect { |vm| vm['virtual_machine'] }
    end

    def data_store_joins(id)
      response = request(:get, "/settings/hypervisors/#{id}/data_store_joins.json")
      response.collect { |dsj| dsj['data_store_join'] }
    end

    def add_data_store_join(id, data_store_id)
      request(:post, "/settings/hypervisors/#{id}/data_store_joins.json", :query => {:data_store_id => data_store_id})
    end

    def remove_data_store_join(id, data_store_join_id)
      request(:delete, "/settings/hypervisors/#{id}/data_store_joins/#{data_store_join_id}.json")
    end

    def network_joins(id)
      response = request(:get, "/settings/hypervisors/#{id}/network_joins.json")
      response.collect { |nj| nj['network_join'] }
    end

    def add_network_join(id, options)
      request(:post, "/settings/hypervisors/#{id}/network_joins.json", :query => {:network_join => options})
    end

    def remove_network_join(id, network_join_id)
      request(:delete, "/settings/hypervisors/#{id}/network_joins/#{network_join_id}.json")
    end
  end
end
