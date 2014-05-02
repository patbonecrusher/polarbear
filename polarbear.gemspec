# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polarbear/version'

Gem::Specification.new do |spec|
  spec.name          = 'polarbear'
  spec.version       = Polarbear::VERSION
  spec.authors       = ['Bone Crusher']
  spec.email         = %w(pat@covenofchaos.com)
  spec.description   = %q{smart bear code collaborator command line ruby interface}
  spec.summary       = %q{this is a work in progress}
  spec.homepage      = 'https://github.com/patbonecrusher/polarbear'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'cli-colorize'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'growl_notify'
  spec.add_development_dependency 'version'

  spec.add_dependency 'os'
  spec.add_dependency 'file-find'
  spec.add_dependency 'highline'
  spec.add_dependency 'nori'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'xml-fu'
  spec.add_dependency 'addressable'
  spec.add_dependency 'command-dispatcher'
  spec.add_dependency 'gitit', '1.1.0'

end
