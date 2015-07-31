require 'securerandom'

module TinyMVC
  class SessionMiddleware
    @@sessions = {}

    def initialize(app)
      @app = app
    end

    def call(env)
      token = parse_cookie(env['HTTP_COOKIE'] || '')['_session']
      unless @@sessions[token]
        token = generate_token
        @@sessions[token] = {}
      end
      env['rack.session'] = token
      env['rack.session.data'] = @@sessions[token]
      code, header, body = @app.call(env)
      @@sessions[token] = env['rack.session.data']
      [code, header.merge('Set-Cookie' => "_session=#{token}; path=/"), body]
    end

    private

    def generate_token
      SecureRandom.hex
    end

    def parse_cookie(cookie_string)
      Hash[cookie_string.split('; ').map { |s| s.split('=') }]
    end
  end
end


