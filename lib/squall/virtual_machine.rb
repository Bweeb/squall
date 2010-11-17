module Squall
  class VirtualMachine < Client

    URI_PREFIX   = 'virtual_machines'
    VALID_PARAMS = [:primary_network_id, 
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
                    :initial_root_password ]

    def list
      if get(URI_PREFIX)
        @message.collect { |res| res['virtual_machine'] }
      else
        []
      end
    end

    def show(id)
      get("#{URI_PREFIX}/#{id}") ? @message['virtual_machine'] : false
    end

    def edit(id, params = {})
      valid_options!(VALID_PARAMS, params)
      put("#{URI_PREFIX}/#{id}", { :virtual_machine => params }) 
    end

    def create(params = {})
      required = [ :memory, :cpus, :label, :template_id, :hypervisor_id, :initial_root_password ]
      required_options!(required, params)
      post(URI_PREFIX, { :virtual_machine => params })
    end

    def destroy(id)
      delete("#{URI_PREFIX}/#{id}")
    end

    def reboot(id)
      post("#{URI_PREFIX}/#{id}/reboot")
    end

    def search(pattern, *fields)
      fields = [:label] if fields.empty?
      valid_options!(VALID_PARAMS, fields)
      list.select do |vm| 
        fields.detect { |field| vm.has_key?(field.to_s) && vm[field.to_s].to_s.match(/#{pattern}/) }
      end
    end
  end
end
