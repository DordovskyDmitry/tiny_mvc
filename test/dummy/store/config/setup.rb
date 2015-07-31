require 'tiny_mvc'

module Store
  class Application < TinyMVC::Application
    app.middleware_stack.insert 0, Rack::Static, {:urls => ['/css'], :root => 'public'}
    app.middleware_stack.insert 1, TinyMVC::SessionMiddleware
    app.load_paths << 'lib'
  end
end
