# frozen_string_literal: true

require_relative "lib/sunsetter/version"

Gem::Specification.new do |spec|
  spec.name = "sunsetter"
  spec.version = Sunsetter::VERSION
  spec.authors = ["ryoh827"]
  spec.email = ["ryoh827.dev@gmail.com"]

  spec.summary = "A gem to mark Mongoid fields as deprecated with warning messages"
  spec.description = "Sunsetter provides a simple way to mark Mongoid fields as deprecated and show warning messages when they are accessed."
  spec.homepage = "https://github.com/ryoh827/sunsetter"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)}) || f.match(/\.gem$/)
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid", ">= 7.0.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "ostruct", "~> 0.5.0"
  spec.add_development_dependency "standard", "~> 1.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
