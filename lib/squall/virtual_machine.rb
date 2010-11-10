module Squall
  class VirtualMachine < Client

    URI_PREFIX = 'virtual_machines'

    def list
      servers = []
      get(URI_PREFIX).each { |res| servers.push(res['virtual_machine']) }
      servers
    end

    def show(id)
      get("#{URI_PREFIX}/#{id}")['virtual_machine']
    end

    def edit(id, params = {})
      valid = { :primary_network_id, 
                :cpus, 
                :label, 
                :cpu_shares, 
                :template_id, 
                :swap_disk_size,
                :memory, 
                :required_virtual_machine_build, 
                :hypervisor_id, 
                :required_ip_address_assignment,
                :rate_limit, 
                :primary_disk_size,
                :hostname,
                :initial_root_password }
      valid_options!(valid, params)
      put("#{URI_PREFIX}/#{id}", params)
    end

    def create(params = {})
      required = { :memory, :cpus, :label, :template_id, :hypervisor_id, :initial_root_password }
      required_options!(required, params)
      post(URI_PREFIX, { :virtual_machine => params })['virtual_machine']
    end

    def destroy(id)
      delete("#{URI_PREFIX}/#{id}")
    end
  end
end
