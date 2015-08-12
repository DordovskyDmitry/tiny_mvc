require 'fileutils'
require_relative '../tiny_mvc/mvc/template'


module TinyMVC
  module Generators
    class App
      def initialize(name, options = {})
        @name, @options = name, options
        @app = name.split(/[_-]/).map(&:capitalize).join('')
        @template = Template.new(self)
      end

      def generate!
        current_dir = File.dirname(__FILE__)
        mkdir @name do
          mkdir 'app' do
            mkdir 'controllers'
            mkdir 'models'
            mkdir 'views'
          end
          mkdir 'config' do
            create_file('setup.rb', "#{current_dir}/templates/setup.rb.erb")
            create_file('routes.rb', "#{current_dir}/templates/routes.rb.erb")
            create_file('redis.json', "#{current_dir}/templates/redis.json.erb")
          end
          mkdir 'lib'
          mkdir 'public' do
            mkdir 'css'
            mkdir 'javascripts'
            mkdir 'images'
          end
          create_file('config.ru', "#{current_dir}/templates/config.ru.erb")
        end
      end

      def get_binding
        binding
      end

      private

      def mkdir(name)
        pwd = FileUtils.pwd
        FileUtils.mkdir(name.to_s)
        FileUtils.cd(name.to_s)
        block_given? ? yield : FileUtils.touch('.gitkeep')
        FileUtils.cd(pwd)
      end

      def create_file(name, template = nil)
        interior = @template.render(template) if template
        File.open(name, 'w+'){ |file| file.write interior }
      end
    end
  end
end