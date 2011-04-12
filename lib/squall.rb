require 'httparty'
require 'squall/version'

autoload :Params,  'params'

module Squall
	autoload :Config,  'squall/config'
	autoload :Base,    'squall/base'
	autoload :User,    'squall/user'


  extend self
  attr_accessor :configuration
  self.configuration ||= Squall::Config.new

	def config
    yield self.configuration if block_given?
    self.configuration.config
  end

  def reset_config
    self.configuration = Squall::Config.new
  end
end