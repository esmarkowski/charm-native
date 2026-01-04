# frozen_string_literal: true

require_relative "lib/charm/native/version"

Gem::Specification.new do |spec|
  spec.name = "charm-native"
  spec.version = Charm::Native::VERSION
  spec.authors = ["Marco Roth"]
  spec.email = ["marco.roth@intergga.ch"]

  spec.summary = "Shared native extension for Charm Ruby ports."
  spec.description = "Single native extension (Go c-archive + Ruby C extension) shared by Bubbletea/Lipgloss to avoid loading multiple Go runtimes in one Ruby process."
  spec.homepage = "https://github.com/marcoroth"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir[
    "charm-native.gemspec",
    "LICENSE.txt",
    "README.md",
    "lib/**/*.rb",
    "ext/**/*.{c,h,rb}",
    "go/**/*.{go,mod,sum}",
    "go/build/**/*"
  ]

  spec.require_paths = ["lib"]
  spec.extensions = ["ext/charm_native/extconf.rb"]
end
