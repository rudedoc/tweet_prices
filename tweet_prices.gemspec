# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tweet_prices'

Gem::Specification.new do |gem|
  gem.name          = "tweet_prices"
  gem.version       = TweetPrices::VERSION
  gem.authors       = ["rudedoc"]
  gem.email         = ["finlay.mark@gmail.com"]
  gem.description   = %q{Scans data sources and tweets the top price.}
  gem.summary       = %q{Scans data sources and tweets the top price.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
