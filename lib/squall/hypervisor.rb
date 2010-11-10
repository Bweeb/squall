module Squall
  class Hypervisor < Client

    URI_PREFIX = 'settings/hypervisors'

    def settings
      if get(URI_PREFIX)
        @response.collect { |res| res['hypervisor'] }
      else
        false
      end
    end

    def show(id)
      begin
        get("#{URI_PREFIX}/#{id}") ? @response['hypervisor'] : false
      rescue RestClient::ResourceNotFound
        false
      end
    end

    def create(params = {})
      required = { :ip_address, :label }
      required_options!(required, params)
      begin
        parse(post(URI_PREFIX, { :hypervisor => params }), 201)
      rescue Exception => e
        parse(e.response)
        raise @response.collect { |k,v| "#{k}: #{v}" }.join ", "
      end
    end

  end
end
