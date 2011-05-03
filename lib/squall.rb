require 'httparty'

require 'squall/version'
require 'squall/exception'

module Squall
  autoload :Params,         'squall/params'
  autoload :Hypervisor,     'squall/hypervisor'
  autoload :Config,         'squall/config'
  autoload :Base,           'squall/base'
  autoload :User,           'squall/user'
  autoload :Role,           'squall/role'
  autoload :Network,        'squall/network'
  autoload :IpAddress,      'squall/ip_address'
  autoload :Template,       'squall/template'
  autoload :VirtualMachine, 'squall/virtual_machine'
  autoload :Statistic,      'squall/statistic'
  autoload :Transaction,    'squall/transaction'

  extend self
  attr_accessor :configuration, :configuration_file
  self.configuration ||= Squall::Config.new

  def config
    yield self.configuration if block_given?
    self.configuration.config
  end

  def config_file(file = nil)
    file = File.expand_path(File.expand_path(File.join(ENV['HOME'], '.squall.yml'))) if file.nil?
    if File.exists?(file)
      self.configuration_file = file
    else
      raise ArgumentError, "Config file doesn't exist '#{file}'"
    end
    config do |c|
      conf = YAML::load_file(file)
      c.base_uri  conf['base_uri']
      c.username  conf['username']
      c.password  conf['password']
    end
  end

  def reset_config
    self.configuration = Squall::Config.new
  end
end
