module Squall
  # OnApp DataStoreZone
  class DataStoreZone < Base
    # Returns a list of DataStoreZones
    def list
      response = request(:get, "/data_store_zones.json")
      response.collect { |i| i['data_store_group'] }
    end
    
    # Get the details for a data store zone
    def show(id)
      response = request(:get, "/data_store_zones/#{id}.json")
      response['data_store_group']
    end

    # Updates an existing DataStoreZone
    #
    # ==== Options
    # * +options+ - Params for updating the data store zone
    def edit(id, options = {})
      params.required(:label).validate!(options)
      response = request(:put, "/data_store_zones/#{id}.json", :query => {:pack => options})
    end

    # Creates a new DataStoreZone
    #
    # ==== Options
    # * +options+ - Params for the new IP address
    def create(options = {})
      params.required(:label).validate!(options)
      response = request(:post, "/data_store_zones.json", :query => {:pack => options})
    end

    # Deletes an existing DataStoreZone
    #
    # ==== Options
    # * +id+ - required
    def delete(id)
      request(:delete, "/data_store_zones/#{id}.json")
    end
  end
end
