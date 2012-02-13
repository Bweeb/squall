require 'httparty'

require 'squall/support/version'
require 'squall/support/exception'
require 'squall/support/yaml'

module Squall
  autoload :Params,         'squall/support/params'
  autoload :Config,         'squall/support/config'
  autoload :Base,           'squall/support/base'
  autoload :Hypervisor,     'squall/hypervisor'
  autoload :User,           'squall/user'
  autoload :Role,           'squall/role'
  autoload :Network,        'squall/network'
  autoload :IpAddress,      'squall/ip_address'
  autoload :IpAddressJoin,  'squall/ip_address_join'
  autoload :Template,       'squall/template'
  autoload :VirtualMachine, 'squall/virtual_machine'
  autoload :Statistic,      'squall/statistic'
  autoload :Transaction,    'squall/transaction'

  extend self

  # Config
  attr_accessor :configuration

  # Config 
  attr_accessor :configuration_file

  # The path to your squall.yml
  self.configuration ||= Squall::Config.new

  # Specificy the config via block
  # 
  # ==== Attributes
  #
  # * +base_uri+ - URL of your OnApp instance
  # * +username+ - API username
  # * +password+ - API Password
  # * +debug+ - Toggle debug mode to log HTTParty
  #
  # ==== Example
  #
  #   Squall.config do |c|
  #     c.base_uri 'http://onapp.myserver.com'
  #     c.username 'myuser'
  #     c.password 'mypass'
  #   end
  def config
    yield self.configuration if block_given?
    self.configuration.config
  end

  # Load the config from a YAML file
  #
  # ==== Options
  #
  # * +file+ - Path to the YAML file (default is ~/.squall.yml)
  #
  # ==== Example
  #
  #   Squall.config_file # (loads ~/.squall.yml)
  #
  #   Squall.config_file '/path/to/squall.yml'
  #
  def config_file(file = nil)
    file = File.expand_path(File.expand_path(File.join(ENV['HOME'], '.squall.yml'))) if file.nil?
    if File.exists?(file)
      self.configuration_file = file
    else
      raise ArgumentError, "Config file doesn't exist '#{file}'"
    end
    settings = YAML::load_file(file)
    config do |c| 
      settings.each { |k, v| c.send(k, v) }
    end
  end

  # Reset the config (aka, clear it)
  def reset_config
    self.configuration = Squall::Config.new
  end
end
