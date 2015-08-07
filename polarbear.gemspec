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
  spec.add_development_dependency 'rake', '= 10.3.1'
  spec.add_development_dependency 'rspec', '= 2.14.1'
  spec.add_development_dependency 'guard-rspec', '= 4.2.8'
  spec.add_development_dependency 'cli-colorize', '= 2.0.0'
  spec.add_development_dependency 'simplecov', '= 0.8.2'
  spec.add_development_dependency 'libnotify', '~> 0'
  spec.add_development_dependency 'version', '= 1.0.0'

  spec.add_dependency 'os', '= 0.9.6'
  spec.add_dependency 'file-find', '~> 0.3'
  spec.add_dependency 'highline', '= 1.6.21'
  spec.add_dependency 'nori', '= 2.4.0'
  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'xml-fu', '= 0.2.0'
  spec.add_dependency 'addressable', '= 2.3.6'
  spec.add_dependency 'command-dispatcher', '= 0.2.0'
  spec.add_dependency 'gitit', '~> 2.0'

  spec.add_dependency 'win32-file', '~> 0'
  spec.add_dependency 'win32-security', '~> 0'

end
