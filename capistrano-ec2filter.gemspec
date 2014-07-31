# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/ec2filter/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-ec2filter"
  spec.version       = Capistrano::Ec2filter::VERSION
  spec.authors       = ["Michał Rogowski"]
  spec.email         = ["michal.rogowski1@gmail.com"]
  spec.summary       = %q{Get DNS/ip addresses of AWS EC2 instances filtered by custom criteria}
  spec.description   = %q{Get DNS/ip addresses of AWS EC2 instances filtered by custom criteria (tag, name, status etc)}
  spec.homepage      = "https://github.com/rogal111/capistrano-ec2filter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", "~>2.1"
  spec.add_dependency "aws-sdk", "~>1.3"
end
