# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiny_mvc/version'

Gem::Specification.new do |spec|
  spec.name          = "tiny_mvc"
  spec.version       = TinyMVC::VERSION
  spec.authors       = ["Dmytro Dordovskyi"]
  spec.email         = ["dordovskydmitry@gmail.com"]
  spec.summary       = %q{Small ruby MVC web framework.}
  spec.description   = %q{Small ruby MVC web framework with rails-like api.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['tiny_mvc']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
  spec.add_dependency "rack"
  spec.add_dependency "redis", "~> 3.2"
end
