Gem::Specification.new do |s|
  s.name = "webmachine-mongrel2"
  s.version = "0.0.2"
  s.platform = Gem::Platform::RUBY
  s.authors = ["Blake Sweeney"]
  s.email = "blakes.85@gmail.com"
  s.homepage = "http://www.github.com/blakesweeney/ruby-webmachine-mongrel2"
  s.summary = "Adapter from Mongrel2 to Webmachine-ruby"
  s.description = "Adapter from Mongrel2 to Webmachine-ruby"

  # Dependecies
  s.add_dependency('mongrel2', '~> 0.20.1')
  s.add_dependency('webmachine', '~> 0.4.0')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
