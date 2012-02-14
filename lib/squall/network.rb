module Squall
  # OnApp Network
  class Network < Base
    # Returns a list of Networks
    def list
      response = request(:get, '/settings/networks.json')
      response.collect { |network| network['network'] }
    end

    # Edit a Network
    #
    # ==== Params
    #
    # * +id*+ - ID of the network
    # * +options+ - Params for editing the Network
    #
    # ==== Options
    #
    # See #create
    #
    # ==== Example
    #
    #   edit 1, :label => 'mynetwork', :network_group_id => 1, :vlan => 2, :identifier => 'something'
    def edit(id, options = {})
      params.accepts(:label, :network_group_id, :vlan, :identifier).validate!(options)
      response = request(:put, "/settings/networks/#{id}.json", default_params(options))
    end

    # Create a Network
    #
    # ==== Params
    #
    # * +options+ - Params for creating the Network
    #
    # ==== Options
    #
    # * +label*+
    # * +vlan+
    # * +identifier+
    #
    # ==== Example
    #
    #   create :label => 'mynetwork', :network_group_id => 1, :vlan => 2, :identifier => 'something'
    def create(options = {})
      params.accepts(:vlan, :identifier).required(:label).validate!(options)
      response = request(:post, '/settings/networks.json', default_params(options))
      response.first[1]
    end

    # Delete a network
    #
    # ==== Params
    #
    # * +id*+ - ID of the network
    def delete(id)
      request(:delete, "/settings/networks/#{id}.json")
    end
  end
end
