# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "activerecord-explain-analyze/version"

Gem::Specification.new do |spec|
  spec.name          = "activerecord-explain-analyze"
  spec.version       = ActiveRecordExplainAnalyze::VERSION
  spec.authors       = ["Peter Graham"]
  spec.email         = ["peterghm@gmail.com"]
  spec.licenses      = ["MIT"] 

  spec.summary       = %q{ActiveRecord#explain with support for EXPLAIN ANALYZE and a variety of output formats}
  spec.description   = %q{Extends ActiveRecord#explain with support for EXPLAIN ANALYZE and output formats of JSON, XML, and YAML.}
  spec.homepage      = "https://github.com/6/activerecord-explain-analyze"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 4"
  spec.add_dependency "pg"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "bundler-audit"
end
