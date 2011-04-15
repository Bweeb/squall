module Squall
  class Hypervisor < Base
    def list
      req = request(:get, '/settings/hypervisors.json')
      req.collect { |hv| hv['hypervisor'] }
    end

    def show(id)
      req = request(:get, "/settings/hypervisors/#{id}.json")
      req.first[1]
    end

    def create(options = {})
      params.required(:label, :ip_address, :hypervisor_type).validate!(options)
      req = request(:post, '/settings/hypervisors.json', default_params(options))
      req.first[1]
    end
  end
end
