module Application extend self
  def env
    @env ||= ENV.fetch( 'RACK_ENV', 'development' )
  end
  def root
    @root ||= File.join( File.dirname(__FILE__), "app" )
  end
  $:.unshift root
end

require "rack/api"
require 'initializers/boot'
require 'controllers/markets_controller'
require 'models/market'


