# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slack_status_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = "slack_status_tracker"
  spec.version       = SlackStatusTracker::VERSION
  spec.authors       = ["Kyoto Kopz"]
  spec.email         = ["kopz9999@gmail.com"]

  spec.summary       = 'Command line tool to get the status of current users'
  spec.homepage      = 'https://github.com/kopz9999/slack_status_tracker'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'watir', '~> 4.0'
  spec.add_dependency 'headless', '2.2.3'
  spec.add_development_dependency "pry", ">= 0.10.3"
  spec.add_development_dependency "dotenv", ">= 2.1.1"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
