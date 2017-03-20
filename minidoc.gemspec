# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "minidoc/version"

Gem::Specification.new do |spec|
  spec.name = "minidoc"
  spec.version = Minidoc::VERSION
  spec.authors = ["Bryan Helmkamp", "Code Climate"]
  spec.email = ["bryan@brynary.com", "hello@codeclimate.com"]
  spec.summary = %q{Lightweight wrapper for MongoDB documents}
  spec.homepage = "https://github.com/codeclimate/minidoc"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.0.0", "< 5"
  spec.add_dependency "activemodel", ">= 3.0.0", "< 5"
  spec.add_dependency "virtus", "~> 1.0", ">= 1.0.0"
  spec.add_dependency "mongo", "~> 2"
end
