# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-tcp-client"
  spec.version       = "0.1.0"
  spec.authors       = ["Bryan Richardson"]
  spec.email         = ["bryan@activeshadow.com"]
  spec.description   = %q{Fluentd output plugin for persistent TCP connections}
  spec.summary       = %q{Fluentd output plugin for persistent TCP connections}
  spec.homepage      = "https://github.com/activeshadow/fluent-plugin-tcp-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
 
  spec.add_dependency "fluentd", ["~> 0.14.0"]

  spec.add_development_dependency "rake",      ["~> 11.0"]
  spec.add_development_dependency "test-unit", ["~> 3.2"]
end
