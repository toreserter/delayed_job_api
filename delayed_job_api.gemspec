require_relative 'lib/delayed_job_api/version'

Gem::Specification.new do |spec|
  spec.name          = "delayed_job_api"
  spec.version       = DelayedJobApi::VERSION
  spec.authors       = ["Töre Serter"]
  spec.email         = ["toreserter@gmail.com"]

  spec.summary       = %q{API Interface for DJ}
  spec.description   = %q{API Interface for DJ}
  spec.homepage      = "https://github.com/toreserter/delayed_job_api"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/toreserter/delayed_job_api"
  spec.metadata["changelog_uri"] = "https://github.com/toreserter/delayed_job_api/blob/master/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sinatra",         [">= 1.4.4"]
  spec.add_runtime_dependency "rack-protection", [">= 1.5.5"]
  spec.add_runtime_dependency "activerecord",    ["> 3.0.0"]
  spec.add_runtime_dependency "delayed_job",     ["> 2.0.3"]

  spec.add_development_dependency "minitest",  ["~> 4.2"]
  spec.add_development_dependency "rack-test", ["~> 0.6"]
end
