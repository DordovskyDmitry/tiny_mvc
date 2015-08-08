module TinyMVC
  class BaseController

    attr_accessor :headers

    def self.layout(layout = nil)
      layout ? @@layout = layout : @@layout
    end

    def initialize
      @response = Rack::Response.new
      @headers = {'Content-type' => 'text/html'}
    end

    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      begin
        self.send(env['action'])
      rescue NotFoundException => e
        @response.status = 404
        @response.write e.message
      rescue StandardError => e
        @response.status = 500
      ensure
        set_response_type
        @headers.each { |k, v| @response[k] = v }
        return @response.finish
      end
    end

    def get_binding
      binding
    end

    private

    def render(view, locals = {})
      @response.status = 200
      locals = { :layout => self.class.layout }.merge locals if format == 'html'
      @response.write Template.new(self).render("#{view}.#{format}.erb", locals)
    end

    def redirect_to(url)
      @response.status = 301
      @headers['Location'] = url
    end

    def params
      @_params ||= (@request.params.merge(@env['url_params'] || {}))
    end

    def session
      @env['rack.session.data']
    end

    def format
      @request.content_type || 'html'
    end

    def set_response_type
      case format
        when 'html'
          @headers.merge!('Content-type' => 'text/html')
        when 'json'
          @headers.merge!('Content-type' => 'application/json')
      end
    end
  end
end



