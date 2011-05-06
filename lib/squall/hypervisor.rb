module Squall
  # OnApp Hypervisor
  class Hypervisor < Base

    # Returns a list of all Hypervisors
    def list
      req = request(:get, '/settings/hypervisors.json')
      req.collect { |hv| hv['hypervisor'] }
    end

    # Returns the Hypervisor info as a Hash
    #
    # ==== Options
    #
    # * +id+ - The id of the Hypervisor
    def show(id)
      req = request(:get, "/settings/hypervisors/#{id}.json")
      req.first[1]
    end

    # Create a new Hypervisor
    #
    # ==== Options
    #
    # * +options+ - Params for creating the Hypervisor
    #
    # ==== Example
    #
    #   create :label => 'myhv', :ip_address => '127.0.0.1', :hypervisor_type => 'xen'
    def create(options = {})
      params.required(:label, :ip_address, :hypervisor_type).validate!(options)
      req = request(:post, '/settings/hypervisors.json', default_params(options))
      req.first[1]
    end

    # Edit a Hypervisor
    #
    # ==== Options
    #
    # * +options+ - Params for editing the Hypervisor
    # ==== Example
    #
    #   edit :label => 'myhv', :ip_address => '127.0.0.1'
    def edit(id, options ={})
      params.accepts(:label, :ip_address).validate!(options)
      request(:put, "/settings/hypervisors/#{id}.json", default_params(options))
    end

    # Reboot a Hypervisor
    def reboot(id)
      response = request(:get, "/settings/hypervisors/#{id}/rebooting.json")
      response['hypervisor']
    end

    # Delete a Hypervisor
    def delete(id)
      req = request(:delete, "/settings/hypervisors/#{id}.json")
    end
  end
end
