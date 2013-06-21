module Squall
  # OnApp FirewallRule
  class FirewallRule < Base
    # Public: Lists all firewall rules for a virtual machine.
    #
    # vm_id - ID of the virtual machine
    #
    # Returns an Array.
    def list(vm_id)
      response = request(:get, "/virtual_machines/#{vm_id}/firewall_rules.json")
      response.collect { |firewall_rule| user['firewall_rule'] }
    end

    # Public: Create a firewall rule for a virtual machine.
    #
    # vm_id   - ID of the virtual machine
    # options - A Hash of options for the firewall rule:
    #           :address              - IP address or range scope for rule.
    #                                   Leave blank to apply to all.
    #           :command              - DROP or ACCEPT
    #           :network_interface_id - ID of the network interface
    #           :port                 - Port address for rule
    #           :protocol             - TCP or UDP
    #
    # Example
    #
    #     create(
    #       command:              "DROP",
    #       protocol              "TCP",
    #       network_interface_id: 1
    #     )
    #
    # Returns a Hash.
    def create(vm_id, options = {})
      request(:post, "/virtual_machines/#{vm_id}/firewall_rules.json", default_params(options))
    end

    # Public: Edit a firewall rule.
    #
    # vm_id   - ID of the virtual machine
    # id      - ID of the firewall rule
    # options - A Hash of options for the firewall rule, see `#create`.
    #
    # Returns a Hash.
    def edit(vm_id, id, options = {})
      request(:put, "/virtual_machines/#{vm_id}/firewall_rules/#{id}.json", default_params(options))
    end

    # Public: Delete a firewall rule.
    #
    # vm_id - ID of the virtual machine
    # id    - ID of the firewall rule
    #
    # Returns a Hash.
    def delete(vm_id, id)
      request(:delete, "/virtual_machines/#{vm_id}/firewall_rules/#{id}.json")
    end
  end
end
