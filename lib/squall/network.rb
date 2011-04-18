module Squall
  class Network < Base
    def list
      response = request(:get, '/settings/networks.json')
      response.collect { |network| network['network'] }
    end
  end
end
