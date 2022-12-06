# frozen_string_literal: true

require_relative "lib/typhoon/version"

Gem::Specification.new do |spec|
  spec.name = "typhoon"
  spec.version = Typhoon::VERSION
  spec.authors = ["Gary Tou"]
  spec.email = ["gary@garytou.com"]

  spec.summary = "An inclement tunnel through the clouds"
  spec.description = "Expose your local development servers with the help of a typhoon (via cloudflared tunnels)"
  spec.homepage = "https://github.com/garyhtou/typhoon"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_runtime_dependency "activesupport", "~> 6.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
