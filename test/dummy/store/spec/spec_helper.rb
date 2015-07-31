require 'rspec'
require 'rack'
require_relative '../../store/config/setup'

Store::Application.init!(Rack::Builder.new)

RSpec.configure do |c|
  c.mock_with :rspec
  c.before { TinyMVC::RedisModel.connection.flushdb }
end
