Gem::Specification.new do |gem|
  gem.authors		= ["Jeune Asuncion"]
  gem.email		= ["jeunito@gmail.com"]
  gem.description	= %q{Interact with baremetal servers on different providers using knife}
  gem.summary		= %q{Interact with baremetal servers on different providers using knife}
  gem.homepage		= "http://github.com/jeunito/knife-remote"
  gem.add_runtime_dependency 'rubyipmi'
  gem.add_runtime_dependency 'softlayer_api'
  gem.add_runtime_dependency 'mechanize'

  gem.files		= `git ls-files`.split($\)
  gem.name		= "knife-remote"
  gem.require_paths	= ["lib"]
  gem.version		= "0.0.1"
end
