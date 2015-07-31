module TinyMVC
  class Application
    def call(env)
      Object.const_get("#{env['controller'].capitalize}Controller").new.call(env)
    rescue StandardError => e
      [500, {}, [e.message]]
    end
  end
end

