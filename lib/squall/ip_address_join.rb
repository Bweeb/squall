module Squall
  # Handles IP assignments for virtual machines
  class IpAddressJoin < Base
    # Public: List IP address assignments for a virtual machine.
    #
    # virtual_machine_id - Virtual machine ID to lookup
    #
    # Returns an Array.
    def list(virtual_machine_id)
      response = request(:get, "/virtual_machines/#{virtual_machine_id}/ip_addresses.json")
      response.collect { |ip| ip['ip_address_join'] }
    end

    # Public: Assigns an IP address to a VM.
    #
    # virtual_machine_id - Virtual machine ID to assign IP to
    # options            - Params for IP assignment:
    #                      :ip_address_id        - ID of the IP address
    #                      :network_interface_id - ID of the network interface
    #
    # Returns a Hash.
    def assign(virtual_machine_id, options = {})
      response = request(:post, "/virtual_machines/#{virtual_machine_id}/ip_addresses.json", default_params(options))
      response['ip_address_join']
    end

    # Public: Deletes an IP address assignment from a VM
    #
    # virtual_machine_id - Virtual machine ID to remove IP join from
    # ip_address_id      - IP Address ID to remove, see `#assign`.
    #
    # Returns a Hash.
    def delete(virtual_machine_id, ip_address_id)
      request(:delete, "/virtual_machines/#{virtual_machine_id}/ip_addresses/#{ip_address_id}.json")
    end
  end
end
