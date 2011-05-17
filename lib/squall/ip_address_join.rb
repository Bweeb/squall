module Squall
  # Handles IP assignments for virtual machines
  class IpAddressJoin < Base

    # OnApp uses params[:ip_address] for joins, so we need to override
    # key_for_class accordingly.
    def key_for_class
      'ip_address'
    end

    # Get the list of IP address assignments for a particular VM
    #
    # ==== Options
    # * +virtual_machine_id+ - Virtual machine ID to lookup
    def list(virtual_machine_id)
      response = request(:get, "/virtual_machines/#{virtual_machine_id}/ip_addresses.json")
      response.collect { |ip| ip['ip_address_join'] }
    end

    # Assigns an IP address to a VM
    #
    # ==== Options
    # * +virtual_machine_id+ - Virtual machine ID to assign IP to
    # * +options+ - Params for IP assignment
    def assign(virtual_machine_id, options = {})
      params.required(:ip_address_id, :network_interface_id).validate!(options)
      response = request(:post, "/virtual_machines/#{virtual_machine_id}/ip_addresses.json", default_params(options))
      response['ip_address_join']
    end

    # Deletes an IP address assignment from a VM
    #
    # ==== Options
    # * +virtual_machine_id+ - Virtual machine ID to remove IP join from
    # * +ip_address_id+ - IP Address ID to remove
    def delete(virtual_machine_id, ip_address_id)
      request(:delete, "/virtual_machines/#{virtual_machine_id}/ip_addresses/#{ip_address_id}.json")
    end
  end
end
