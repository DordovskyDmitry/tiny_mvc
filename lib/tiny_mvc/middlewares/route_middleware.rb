module TinyMVC
  class RouteMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request, matched = Rack::Request.new(env)
      route = TinyMVC::Router.routes.detect do |route|
        matched = route.verbs.include?(request.request_method) && request.path.match(route.regexp)
      end
      if route
        env['controller'] = route.entry[:controller]
        env['action'] = route.entry[:action]
        env['url_params'] = Hash[matched.names.zip(matched.captures)]
        @app.call(env)
      else
        [404, {}, ['Resource not found']]
      end
    rescue StandardError => e
      [500, {}, [e.message]]
    end
  end
end
