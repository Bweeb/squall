module Squall
  # OnApp NetworkZone
  class NetworkZone < Base
    # Returns a list of NetworkZones
    def list
      response = request(:get, "/network_zones.json")
      response.collect { |i| i['network_group'] }
    end
    
    # Get the details for a data store zone
    def show(id)
      response = request(:get, "/network_zones/#{id}.json")
      response['network_group']
    end

    # Updates an existing NetworkZone
    #
    # ==== Options
    # * +options+ - Params for updating the data store zone
    def edit(id, options = {})
      params.required(:label).validate!(options)
      response = request(:put, "/network_zones/#{id}.json", :query => {:pack => options})
    end

    # Creates a new NetworkZone
    #
    # ==== Options
    # * +options+ - Params for the new NetworkZone
    def create(options = {})
      params.required(:label).validate!(options)
      response = request(:post, "/network_zones.json", :query => {:pack => options})
    end

    # Deletes an existing NetworkZone
    #
    # ==== Options
    # * +id+ - required
    def delete(id)
      request(:delete, "/network_zones/#{id}.json")
    end
  end
end
