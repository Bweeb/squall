module Squall
  # OnApp FirewallRule
  class FirewallRule < Base

    # Return a list of all firewall rules for a virtual machine
    #
    # ==== Params
    #
    # * +vm_id*+ - ID of the virtual machine
    def list(vm_id)
      response = request(:get, "/virtual_machines/#{vm_id}/firewall_rules.json")
      response.collect { |firewall_rule| user['firewall_rule'] }
    end

    # Create a firewall rule for a virtual machine
    #
    # ==== Params
    #
    # * +vm_id*+ - ID of the virtual machine
    #
    # ==== Options
    #
    # * +command*+ - DROP or ACCEPT
    # * +protocol*+ - TCP or UDP
    # * +network_interface_id*+ - ID of the network interface
    # * +address+ - IP address or range scope for rule.  Leave blank to apply to all.
    # * +port+ - Port address for rule
    #
    # ==== Example
    #
    #   create :command              => "DROP",
    #          :protocol             => "TCP",
    #          :network_interface_id => 1
    def create(vm_id, options={})
      params.required(:command, :protocol, :network_interface_id).accepts(:address, :port).validate!(options)
      request(:post, "/virtual_machines/#{vm_id}/firewall_rules.json", default_params(options))
    end

    # Edit a firewall rule
    #
    # ==== Params
    #
    # * +vm_id+ - ID of the virtual machine
    # * +id+ - ID of the firewall rule
    # * +options+ - Options for the firewall rule.
    #
    # ==== Options
    #
    # See #create
    def edit(vm_id, id, options={})
      params.accepts(:command, :protocol, :network_interface_id, :address, :port).validate!(options)
      request(:put, "/virtual_machines/#{vm_id}/firewall_rules/#{id}.json", default_params(options))
    end

    # Delete a firewall rule
    #
    # ==== Params
    #
    # * +vm_id*+ - ID of the virtual machine
    # * +id+ - ID of the firewall rule
    def delete(vm_id, id)
      request(:delete, "/virtual_machines/#{vm_id}/firewall_rules/#{id}.json")
    end

  end
end
