require 'faraday'
require 'faraday_middleware'

require 'squall/support/version'
require 'squall/support/exception'

module Squall
  # Support
  autoload :Config,         'squall/support/config'
  autoload :Base,           'squall/support/base'
  # Api
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
  autoload :Payment,        'squall/payment'
  autoload :UserGroup,      'squall/user_group'
  autoload :Whitelist,      'squall/whitelist'
  autoload :FirewallRule,   'squall/firewall_rule'
  autoload :DataStoreZone,  'squall/data_store_zone'
  autoload :NetworkZone,    'squall/network_zone'
  autoload :HypervisorZone, 'squall/hypervisor_zone'
  autoload :Disk,           'squall/disk'

  extend self

  # Config
  attr_accessor :configuration

  # Config
  attr_accessor :configuration_file

  self.configuration ||= Squall::Config.new

  # Public: Configures Squall.
  #
  # Yields Squall.configuration if a block is given.
  #
  # Example
  #
  #     Squall.config do |c|
  #       c.base_uri 'http://onapp.myserver.com'
  #       c.username 'myuser'
  #       c.password 'mypass'
  #       c.debug    true
  #     end
  #
  # Returns a Hash.
  def config
    yield self.configuration if block_given?
    self.configuration.config
  end

  # Public: Load the config from a YAML file.
  #
  # file - Path to the YAML file, defaults to `~/.squall.yml`
  #
  # Raises ArgumentError if the config file does not exist.
  #
  # Example
  #
  #     # Load default config file at `~/.squall.yml`:
  #     Squall.config_file
  #
  #     # Load custom config file:
  #     Squall.config_file '/path/to/squall.yml'
  #
  # Returns nothing.
  def config_file(file = File.expand_path("~/.squall.yml"))
    if File.exists?(file)
      self.configuration_file = file
    else
      raise ArgumentError, "Config file doesn't exist '#{file}'"
    end

    config do |c|
      YAML::load_file(file).each { |k, v| c.send(k, v) }
    end
  end

  # Public: Reset the config (aka, clear it)
  #
  # Returns an instance of Squall::Config.
  def reset_config
    self.configuration = Squall::Config.new
  end
end
