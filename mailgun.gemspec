# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Akash Manohar J", "Sean Grove"]
  gem.email         = ["akash@akash.im", "s@bushi.do", "sean@fakecoolguys.com"]
  gem.description   = %q{Mailgun library for Ruby}
  gem.summary       = %q{Idiomatic library for using the mailgun API from within ruby}
  gem.homepage      = "http://github.com/Bushido/mailgun"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "mailgun"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.3"
  
  gem.add_dependency(%q<rest-client>, [">= 0"])
end
