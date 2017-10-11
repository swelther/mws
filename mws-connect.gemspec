# -*- encoding: utf-8 -*-

require File.expand_path('../lib/mws/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'mws-connect'
  gem.version       = Mws::VERSION
  gem.authors       = ['Sebastian Welther', 'Sean M. Duncan', 'John E. Bailey']
  gem.license       = 'MIT'
  gem.email         = ['info@devmode.com']
  gem.description   = %q{The missing ruby client library for Amazon MWS}
  gem.summary       = %q{The missing ruby client library for Amazon MWS}
  gem.homepage      = 'http://github.com/swelther/mws'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|specs?|feat(ures?)?)/})
  gem.require_paths = ['lib']
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'activesupport'
  gem.add_dependency 'logging', '>= 1.8'
  gem.add_dependency 'nokogiri', '~> 1.6'
end
