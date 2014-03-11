# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'general_units/version'

Gem::Specification.new do |gem|
  gem.name          = "general_units"
  gem.version       = GeneralUnits::VERSION
  gem.authors       = ["Valery Kvon"]
  gem.email         = ["addagger@gmail.com"]
  gem.homepage      = %q{http://vkvon.ru/projects/general_units}
  gem.description   = %q{World's units}
  gem.summary       = %q{Weight Length Power and other general units}

  gem.rubyforge_project = "general_units"

  gem.add_development_dependency "i18n", '~> 0.6'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.licenses       = ['MIT']
end