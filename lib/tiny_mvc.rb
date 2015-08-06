require 'tiny_mvc/version'
require 'tiny_mvc/require_all'
require 'singleton'

module TinyMVC
  class << self
    attr_reader :app

    def root
      app && app.root
    end
  end

  class Application
    def self.inherited(base)
      base.include(Singleton)
      TinyMVC.instance_variable_set(:@app, base.instance)
    end

    class << self
      def app
        instance
      end

      def method_missing(*args)
        instance.send(*args)
      end

      def respond_to_missing?(method_name, include_private = false)
        instance.respond_to?(method_name) || super
      end
    end

    attr_reader :middleware_stack, :load_paths, :root

    def initialize
      @middleware_stack = MiddlewareStack.new
      @load_paths = %w(config app)
      @root = ENV['PWD']
    end

    def init!
      init_middlewares
      load_app
    end

    def call(env)
      @app_stack.call(env)
    rescue StandardError => e
      [500, {}, [e.message]]
    end

    private

    def init_middlewares
      middleware_stack.insert(ApplicationMiddleware.new)
      @app_stack = middleware_stack.reverse.reduce { |app, wrapper|
        wrapper.wrap(app.rack_app)
      }.rack_app
    end

    def load_app
      load_paths.each do |path|
        Dir[File.join(root, path, '**/*.rb')].each { |f| require f }
      end
    end
  end

  class MiddlewareStack
    DEFAULT_STACK = [Rack::MethodOverride, TinyMVC::RouteMiddleware]

    def initialize
      @stack = []
      DEFAULT_STACK.each { |m| self.insert(m) }
    end

    def insert(*args)
      index, *middleware = args.first.is_a?(Integer) ? args : [@stack.size, *args]
      @stack.insert(index, Middleware.new(*middleware))
    end

    def reverse
      @stack.reverse
    end

    def each
      if block_given?
        @stack.each { |m| yield(m) }
      else
        @stack.each
      end
    end
  end

  class Middleware < Struct.new(:rack_app, :options)
    def wrap(app)
      ra = options ? rack_app.new(app, options) : rack_app.new(app)
      Middleware.new(ra)
    end
  end
end
