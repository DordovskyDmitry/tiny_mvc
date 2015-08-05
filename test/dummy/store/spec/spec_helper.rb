require 'rspec'
require 'rack'
require 'rack/test'
require_relative '../../store/config/setup'
Store::Application.init!(Rack::Builder.new)

RSpec.configure do |c|
  c.mock_with :rspec
  c.include Rack::Test::Methods
  c.before { TinyMVC::RedisModel.connection.flushdb }
end
