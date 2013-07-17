ENV['RACK_ENV'] = 'test'
require File.expand_path( "../../application", __FILE__ )
require "rspec"
require "rack/test"
require 'mongoid-rspec'
require 'database_cleaner'

RSpec.configure do |config|

  config.include Rack::Test::Methods

  config.include Mongoid::Matchers

  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end