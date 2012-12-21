# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'struct_module/version'

Gem::Specification.new do |gem|
  gem.name          = "struct_module"
  gem.version       = StructModule::VERSION
  gem.authors       = ["HORII Keima"]
  gem.email         = ["holysugar@gmail.com"]
  gem.description   = %q{includable Struct}
  gem.summary       = %q{includable Struct}
  gem.homepage      = "https://github.com/holysugar/struct_module"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
