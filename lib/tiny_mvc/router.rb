require 'singleton'
require 'ostruct'

module TinyMVC
  class Router
    include Singleton
    ACCEPTABLE_HTTP_VERBS = %w(GET POST)

    @@routes = []

    def self.routes
      @@routes
    end

    def self.draw(&block)
      instance.instance_eval &block
    end

    def match(mask, entry, verbs = ACCEPTABLE_HTTP_VERBS)
      @@routes << OpenStruct.new(regexp: parse(mask), entry: entry, verbs: verbs)
    end

    ACCEPTABLE_HTTP_VERBS.each do |verb|
      define_method verb.downcase do |mask, entry|
        match(mask, entry, [verb])
      end
    end

    def root(entry)
      @@routes.insert(0, OpenStruct.new(regexp: /\A\/\z/, entry: entry, verbs: ['GET']))
    end

    private

    def parse(rule)
      path, format = rule.split('.')
      /\A#{path_regex(path)}#{format_regex(format)}\z/
    end

    def path_regex(path)
      path.split('/').map { |part| part[0] == ':' ? "(?<#{part[1..-1]}>[^\.\/\?]*)" : part }.join('/')
    end

    def format_regex(format)
      return if format.nil?
      format[0] == ':' ? '(\.(?<format>.*))?' : "\.#{format}"
    end
  end
end

#TinyMVC::Router.draw do
#  match ':site/asd/:id.:formt' => {:controller => '', :acton => ''}
#  /\A(?<:site>.*)\/asd/(?<:id>.*)(\.(<?:format>.*))?\z/
#end
