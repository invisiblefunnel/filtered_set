# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'filtered_set'

Gem::Specification.new do |spec|
  spec.name          = "filtered_set"
  spec.version       = FilteredSet::VERSION
  spec.authors       = ["Danny Whalen"]
  spec.email         = ["daniel.r.whalen@gmail.com"]
  spec.description   = %q{An implementation of Ruby's Set which conditionally adds objects based on custom filters.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/invisiblefunnel/filtered_set"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rspec', '~> 2.13'
end
