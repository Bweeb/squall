require 'httparty'
require 'squall/version'

autoload :Params,  'params'

module Squall
  class NotFound < StandardError;end
  class RequestError < StandardError;end
  class ServerError < StandardError;end

  autoload :Hypervisor, 'squall/hypervisor'
  autoload :Config,     'squall/config'
  autoload :Base,       'squall/base'
  autoload :User,       'squall/user'
  autoload :Role,       'squall/role'

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
