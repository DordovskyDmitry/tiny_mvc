require 'tiny_mvc'

module Store
  class Application < TinyMVC::Application
    app.middleware_stack.insert 0, Rack::Reloader
    app.middleware_stack.insert 1, Rack::Static, {:urls => ['/css'], :root => 'public'}
    app.middleware_stack.insert 2, TinyMVC::SessionMiddleware
    app.load_paths << 'lib'
    init!
  end
end
