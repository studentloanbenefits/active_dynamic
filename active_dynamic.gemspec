# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_dynamic/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_dynamic'
  spec.version       = ActiveDynamic::VERSION
  spec.authors       = ['Constantine Lebedev']
  spec.email         = ['koss.lebedev@gmail.com']

  spec.summary       = 'Gem that allows to attach dynamic attributes to ActiveRecord model'
  spec.description   = 'Gem that allows to attach dynamic attributes to ActiveRecord model'
  spec.homepage      = 'https://github.com/koss-lebedev/active_dynamic'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 4.0'
  spec.add_dependency 'sanitize', '~> 4.6.4'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'sqlite3'
end
