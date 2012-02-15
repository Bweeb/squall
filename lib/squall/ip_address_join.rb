module Squall
  # Handles IP assignments for virtual machines
  class IpAddressJoin < Base

    # Get the list of IP address assignments for a particular virtual machine
    #
    # ==== Params
    #
    # * +virtual_machine_id*+ - Virtual machine ID to lookup
    def list(virtual_machine_id)
      response = request(:get, "/virtual_machines/#{virtual_machine_id}/ip_addresses.json")
      response.collect { |ip| ip['ip_address_join'] }
    end

    # Assigns an IP address to a VM
    #
    # ==== Params
    #
    # * +virtual_machine_id*+ - Virtual machine ID to assign IP to
    # * +options+ - Params for IP assignment
    #
    # ==== Options
    #
    # * +ip_address_id*+ - ID of the IP address
    # * +network_interface_id*+ - ID of the network interface id
    def assign(virtual_machine_id, options = {})
      params.required(:ip_address_id, :network_interface_id).validate!(options)
      response = request(:post, "/virtual_machines/#{virtual_machine_id}/ip_addresses.json", default_params(options))
      response['ip_address_join']
    end

    # Deletes an IP address assignment from a VM
    #
    # ==== Params
    #
    # * +virtual_machine_id+ - Virtual machine ID to remove IP join from
    # * +ip_address_id+ - IP Address ID to remove
    #
    # ==== Options
    #
    # See #assign
    def delete(virtual_machine_id, ip_address_id)
      request(:delete, "/virtual_machines/#{virtual_machine_id}/ip_addresses/#{ip_address_id}.json")
    end
  end
end
