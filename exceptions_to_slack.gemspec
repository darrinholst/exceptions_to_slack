# -*- encoding: utf-8 -*-
require File.expand_path('../lib/exceptions_to_slack/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Darrin Holst"]
  gem.email         = ["darrinholst@gmail.com"]
  gem.summary       = %q{Send rails exceptions to Slack}
  gem.homepage      = "http://github.com/darrinholst/exceptions_to_slack"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "exceptions_to_slack"
  gem.require_paths = ["lib"]
  gem.version       = ExceptionsToSlack::VERSION

  gem.add_dependency("slack-notifier", "~> 1.4.0")
  gem.add_development_dependency("webmock", "~> 1.18.0")
end
