module Squall
  class VirtualMachine < Base
    def list
      response = request(:get, '/virtual_machines.json')
      response.collect { |v| v['virtual_machine'] }
    end

    def show(id)
      response = request(:get, "/virtual_machines/#{id}.json")
      response.first[1]
    end

    def create(options = {})
      required = [:label, :hypervisor_id, :hostname, :memory, :cpus, :cpu_shares, :primary_disk_size]
      optional = [:cpu_shares,
                  :swap_disk_size,
                  :primary_network_id,
                  :required_automatic_backup,
                  :rate_limit,
                  :required_ip_address_assignment,
                  :required_virtual_machine_build,
                  :admin_note,
                  :note,
                  :allowed_hot_migrate,
                  :template_id,
                  :initial_root_password
      ]
      params.required(required).accepts(optional).validate! options
      response = request(:post, '/virtual_machines.json', default_params(options))
      response['virtual_machine']
    end
  end
end
