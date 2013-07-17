# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'promo/version'

Gem::Specification.new do |spec|
  spec.name          = "promo"
  spec.version       = Promo::VERSION
  spec.authors       = ["Sergey Gopkalo"]
  spec.email         = ["Sergey.Gopkalo@gmail.com"]
  spec.description   = %q{API wrapper for Marketing Opt-In server}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  #spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
