module Squall
  # OnApp HypervisorZone
  class HypervisorZone < Base
    # Returns a list of hypervisor zones
    def list
      response = request(:get, "/settings/hypervisor_zones.json")
      response.collect { |i| i['hypervisor_group'] }
    end
    
    # Get the details for a hypervisor zone
    def show(id)
      response = request(:get, "/settings/hypervisor_zones/#{id}.json")
      response['hypervisor_group']
    end

    # Updates an existing hypervisor zone
    #
    # ==== Options
    # * +options+ - Params for updating the hypervisor zone
    def edit(id, options = {})
      params.required(:label).validate!(options)
      response = request(:put, "/settings/hypervisor_zones/#{id}.json", :query => {:pack => options})
    end

    # Creates a new NetworkZone
    #
    # ==== Options
    # * +options+ - Params for the new hypervisor zone
    def create(options = {})
      params.required(:label).validate!(options)
      response = request(:post, "/settings/hypervisor_zones.json", :query => {:pack => options})
    end

    # Deletes an existing hypervisor zone
    #
    # ==== Options
    # * +id+ - required
    def delete(id)
      request(:delete, "/settings/hypervisor_zones/#{id}.json")
    end
    
  end
end
