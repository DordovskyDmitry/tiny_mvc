require 'erb'

module TinyMVC
  class Template
    def initialize(controller)
      @controller = controller
    end

    def render(template, locals = {})
      view = erb(template).result(@controller.get_binding)
      if locals[:layout]
        erb(locals[:layout]).result(@controller.get_binding { view })
      else
        view
      end
    end

    private

    def erb(view)
      ERB.new(File.open(view, 'r') { |f| f.read })
    end
  end
end
