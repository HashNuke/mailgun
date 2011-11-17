# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Akash Manohar J"]
  gem.email         = ["akash@akash.im"]
  gem.description   = %q{Mailgun library for Ruby}
  gem.summary       = %q{The gem itself is a todo for now}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "mailgun"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"
end
