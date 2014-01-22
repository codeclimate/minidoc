# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "minidoc"
  spec.version       = "0.0.1"
  spec.authors       = ["Bryan Helmkamp"]
  spec.email         = ["bryan@brynary.com"]
  spec.summary       = %q{Lightweight wrapper for MongoDB documents}
  spec.homepage      = "https://github.com/brynary/minidoc"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.0.0"
  spec.add_dependency "activemodel", ">= 3.0.0"
  spec.add_dependency "virtus", "~> 1.0.0"
  spec.add_dependency "mongo", "~> 1.9.2"
  spec.add_development_dependency "rake"
end
