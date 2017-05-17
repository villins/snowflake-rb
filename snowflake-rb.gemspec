# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snowflake-rb/version'

Gem::Specification.new do |spec|
  spec.name          = "snowflake-rb"
  spec.version       = Snowflake::Rb::VERSION
  spec.authors       = ["villins"]
  spec.email         = ["linshao512@gmail.com"]

  spec.summary       = %q{ snowflake ruby impl }
  spec.description   = %q{ snowflake ruby impl }
  spec.homepage      = "https://github.com/villins/snowflake-rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "byebug", "~> 9.0"
end
