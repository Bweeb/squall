module Squall
  # OnApp IpAddress
  class IpAddress < Base
    # Returns a list of IpAddresses
    #
    # ==== Options
    # * +network_id+ - required
    def list(network_id)
      response = request(:get, "/settings/networks/#{network_id}/ip_addresses.json")
      response.collect { |ip| ip['ip_address'] }
    end

    # Updates an existing IpAddress
    #
    # ==== Options
    # * +network_id+ - required
    # * +id+ - required
    # * +options+ - Params for updating the IpAddress
    def edit(network_id, id, options = {})
      params.required(:address, :netmask, :broadcast, :network_address, :gateway).validate!(options)
      response = request(:put, "/settings/networks/#{network_id}/ip_addresses/#{id}.json", default_params(options))
    end

    # Creates a new IpAddress
    #
    # ==== Options
    # * +network_id+ - required
    # * +options+ - Params for the new IP address
    def create(network_id, options = {})
      params.required(:address, :netmask, :broadcast, :network_address, :gateway).validate!(options)
      response = request(:post, "/settings/networks/#{network_id}/ip_addresses.json", default_params(options))
    end

    # Deletes an existing IpAddress
    #
    # ==== Options
    # * +network_id+ - required
    # * +id+ - required
    def delete(network_id, id)
      request(:delete, "/settings/networks/#{network_id}/ip_addresses/#{id}.json")
    end
  end
end
