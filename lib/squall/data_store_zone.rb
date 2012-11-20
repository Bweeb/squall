module Squall
  # OnApp DataStoreZone
  class DataStoreZone < Base
    # Returns a list of data store zones
    def list
      response = request(:get, "/data_store_zones.json")
      response.collect { |i| i['data_store_group'] }
    end

    # Get the details for a data store zone
    #
    # ==== Params
    #
    # * +id+ - ID of the data store zone
    def show(id)
      response = request(:get, "/data_store_zones/#{id}.json")
      response['data_store_group']
    end

    # Updates an existing data store zone
    #
    # ==== Params
    #
    # * +id+ - ID of the data store zone
    # * +options+ - Params for the data store zone
    #
    # ==== Options
    #
    # * +label*+ - Label for the data store zone
    def edit(id, options = {})
      response = request(:put, "/data_store_zones/#{id}.json", :query => {:pack => options})
    end

    # Creates a new DataStoreZone
    #
    # ==== Params
    #
    # * +options+ - Params for the data store zone
    #
    # ==== Options
    #
    # * +label*+ - Label for the data store zone
    def create(options = {})
      response = request(:post, "/data_store_zones.json", :query => {:pack => options})
    end

    # Deletes an existing DataStoreZone
    #
    # ==== Params
    #
    # * +id+ - ID of the data store zone
    def delete(id)
      request(:delete, "/data_store_zones/#{id}.json")
    end
  end
end
