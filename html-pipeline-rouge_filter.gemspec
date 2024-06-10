# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'html_pipeline/node_filter/rouge_filter'

Gem::Specification.new do |spec|
  spec.name          = "html-pipeline-rouge_filter"
  spec.version       = HTMLPipeline::NodeFilter::RougeFilter::VERSION
  spec.authors       = ["Juanito Fatas"]
  spec.email         = ["katehuang0320@gmail.com"]
  spec.summary       = %q{Rouge integration with html-pipeline.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/juanitofatas/html-pipeline-rouge_filter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.1"
  spec.required_rubygems_version = ">= 3.3.22"

  spec.add_dependency "html-pipeline", ">= 3"
  spec.add_dependency "rouge", ">= 4"
  spec.add_dependency "selma", "~> 0.1"
  spec.add_dependency "zeitwerk", "~> 2.5"
end
