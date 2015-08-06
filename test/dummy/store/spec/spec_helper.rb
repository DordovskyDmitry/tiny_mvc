require 'rspec'
require 'rack'
require 'rack/test'
require_relative '../../store/config/setup'

RSpec.configure do |c|
  c.mock_with :rspec
  c.include Rack::Test::Methods
  c.before { TinyMVC::RedisModel.connection.flushdb }
end
