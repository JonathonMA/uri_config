# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uri_config/version'

Gem::Specification.new do |spec|
  spec.name          = "uri_config"
  spec.version       = URIConfig::VERSION
  spec.authors       = ["Jonathon M. Abbott"]
  spec.email         = ["jonathona@everydayhero.com.au"]
  spec.summary       = "extract configuration from URIs"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/JonathonMA/uri_config"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "rubocop", "~> 0.41.2" if RUBY_VERSION >= "1.9"
end
