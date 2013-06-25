module Squall
  # OnApp DataStoreZone
  class DataStoreZone < Base
    # Public: List data store zones.
    #
    # Returns an Array.
    def list
      response = request(:get, "/data_store_zones.json")
      response.collect { |i| i['data_store_group'] }
    end

    # Public: Get the details for a data store zone.
    #
    # id - ID of the data store zone
    #
    # Returns a Hash.
    def show(id)
      response = request(:get, "/data_store_zones/#{id}.json")
      response['data_store_group']
    end

    # Public: Updates an existing data store zone.
    #
    # id      - ID of the data store zone
    # options - Params for the data store zone:
    #           :label - Label for the data store zone
    #
    # Returns an empty Hash.
    def edit(id, options = {})
      request(:put, "/data_store_zones/#{id}.json", query: { pack: options })
    end

    # Public: Creates a new DataStoreZone.
    #
    # options - Params for the data store zone:
    #           :label - Label for the data store zone
    #
    # Returns a Hash.
    def create(options = {})
      request(:post, "/data_store_zones.json", query: { pack: options })
    end

    # Public: Deletes an existing DataStoreZone.
    #
    # id - ID of the data store zone
    #
    # Returns an empty Hash.
    def delete(id)
      request(:delete, "/data_store_zones/#{id}.json")
    end
  end
end
