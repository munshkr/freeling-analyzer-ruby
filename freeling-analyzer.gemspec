# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'freeling/analyzer/version'

Gem::Specification.new do |spec|
  spec.name          = "freeling-analyzer"
  spec.version       = FreeLing::Analyzer::VERSION
  spec.authors       = ["Damián Silvani"]
  spec.email         = ["munshkr@gmail.com"]

  spec.summary       = %q{Ruby wrapper for FreeLing's analyzer tool}
  spec.description   = %q{FreeLing::Analyzer is a Ruby wrapper around
                         `analyzer`, a binary tool included in FreeLing's
                         package that allows the user to process a stream of
                         text with FreeLing.}
  spec.homepage      = "http://munshkr.github.io/freeling-analyzer-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "mocha", "~> 0.14.0"
  spec.add_development_dependency "minitest", "~> 4.7.4"
  spec.add_development_dependency "guard", "~> 1.8.0"
  spec.add_development_dependency "guard-minitest", "~> 0.5.0"
  spec.add_development_dependency "pry"
end
