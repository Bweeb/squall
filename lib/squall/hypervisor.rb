module Squall
  class Hypervisor < Client

    URI_PREFIX = 'settings/hypervisors'

    def settings
      if get(URI_PREFIX)
        @message.collect { |res| res['hypervisor'] }
      else
        false
      end
    end

    def show(id)
      get("#{URI_PREFIX}/#{id}") ? @response['hypervisor'] : false
    end

    def create(params = {})
      required = { :ip_address, :label }
      required_options!(required, params)
      post(URI_PREFIX, { :hypervisor => params })
      @response.code == 201
    end

  end
end
