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
  end
end
