require 'rubygems'
require 'json'
require 'rest_client'
require 'open-uri'

[:client, :virtual_machine, :hypervisor].each do |f|
  require File.join(File.dirname(__FILE__), 'squall', f.to_s)
end

module Squall
 class << self
    attr_accessor :api_endpoint, :api_user, :api_password
    def config(api_user, api_password, api_url)
      @api_user     = api_user
      @api_password = api_password
      @api_endpoint = URI.parse(api_url)
    end
  end
end
