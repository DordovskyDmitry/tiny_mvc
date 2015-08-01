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

      def method_missing(name, args, &block)
        instance.send(name, args, &block)
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

    def init!(builder)
      init_middlewares(builder)
      init_app
    end

    private

    def init_middlewares(builder)
      middleware_stack.each { |m| m.used_by(builder) }
    end

    def init_app
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

    def each
      if block_given?
        @stack.each { |m| yield(m) }
      else
        @stack.each
      end
    end
  end

  class Middleware < Struct.new(:name, :args)
    def used_by(builder)
      args ? builder.use(name, args) : builder.use(name)
    end
  end
end
