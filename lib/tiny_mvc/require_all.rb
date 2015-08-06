require "#{File.dirname(__FILE__)}/router.rb"
require "#{File.dirname(__FILE__)}/exception.rb"
Dir[File.dirname(__FILE__) + '/middlewares/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/mvc/**/*.rb'].each { |file| require file }
