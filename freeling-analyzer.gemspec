# -*- encoding: utf-8 -*-
require File.expand_path('../lib/freeling/analyzer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Damián Silvani"]
  gem.email         = ["munshkr@gmail.com"]
  gem.summary       = %q{Ruby wrapper for FreeLing's analyzer tool}
  gem.description   = %q{FreeLing::Analyzer is a Ruby wrapper around
                         `analyzer`, a binary tool included in FreeLing's
                         package that allows the user to process a stream of
                         text with FreeLing.}
  gem.homepage      = "http://munshkr.github.io/freeling-analyzer-ruby"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "freeling-analyzer"
  gem.require_paths = ["lib"]
  gem.version       = FreeLing::Analyzer::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "mocha", "~> 0.14.0"
  gem.add_development_dependency "minitest", "~> 4.7.4"
  gem.add_development_dependency "guard", "~> 1.8.0"
  gem.add_development_dependency "guard-minitest", "~> 0.5.0"

  gem.add_runtime_dependency "hashie", "~> 2.0.5"
end
