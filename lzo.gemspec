# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lzo/version'

Gem::Specification.new do |spec|
  spec.name          = 'lzo'
  spec.version       = LZO::VERSION
  spec.authors       = ['Aidan Steele']
  spec.email         = ['aidan@awsteele.com']

  spec.summary       = 'LZO bindings for all Rubies + LZOP streaming'
  spec.homepage      = 'https://github.com/aidansteele/lzo'

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ffi', '~> 1'
  spec.add_dependency 'bindata', '~> 2.5'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
end
