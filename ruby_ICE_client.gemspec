# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_ICE_client/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_ICE_client"
  spec.version       = RubyICEClient::VERSION
  spec.authors       = ["sergei-krylov"]
  spec.email         = ["sergei.krylov@itechart-group.com"]
  spec.description   = %q{A ruby client for calling ICE - Immunization Calculation Engine (http://www.hln.com/ice/)}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency "base64"
end
