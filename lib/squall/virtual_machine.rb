module Squall
  class VirtualMachine < Base
    def list
      response = request(:get, '/virtual_machines.json')
      response.collect { |v| v['virtual_machine'] }
    end
  end
end
