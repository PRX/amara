# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amara/version'

Gem::Specification.new do |gem|
  gem.name          = "amara"
  gem.version       = Amara::VERSION
  gem.authors       = ["Andrew Kuklewicz"]
  gem.email         = ["andrew@prx.org"]
  gem.description   = %q{Access the amara.org API}
  gem.summary       = %q{Works with API v1.2, http://amara.readthedocs.org/en/latest/api.html}
  gem.homepage      = "https://github.com/PRX/amara"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency('faraday')
  gem.add_runtime_dependency('faraday_middleware')
  gem.add_runtime_dependency('multi_json')
  gem.add_runtime_dependency('excon')
  gem.add_runtime_dependency('hashie')
  gem.add_runtime_dependency('activesupport')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('minitest')
  gem.add_development_dependency('webmock')
end
