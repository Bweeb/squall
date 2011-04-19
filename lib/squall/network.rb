module Squall
  class Network < Base
    def list
      response = request(:get, '/settings/networks.json')
      response.collect { |network| network['network'] }
    end

    def edit(id, options = {})
      params.accepts(:label, :network_group_id, :vlan, :identifier).validate!(options)
      response = request(:put, "/settings/networks/#{id}.json", default_params(options))
    end
  end
end
