# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-paginate/version'

Gem::Specification.new do |spec|
  spec.name          = "octopress-paginate"
  spec.version       = Octopress::Paginate::VERSION
  spec.authors       = ["Brandon Mathis"]
  spec.email         = ["brandon@imathis.com"]
  spec.summary       = %q{A nice and simple paginator for Jekyll sites.}
  spec.homepage      = "https://github.com/octopress/paginate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").grep(/^(bin\/|lib\/|assets\/|demo\/|changelog|readme|license)/i)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "octopress-hooks"

  spec.add_development_dependency "clash"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "octopress-multilingual"

  if RUBY_VERSION >= "2"
    spec.add_development_dependency "pry-byebug"
  end
end
