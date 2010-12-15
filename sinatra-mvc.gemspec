spec = Gem::Specification.new do |s|
  s.name = 'sinatra-mvc'
  s.version = '0.1'
  s.summary = 'MVC stack on top of Sinatra'
  s.platform = Gem::Platform::RUBY
  s.description = 'A custom MVC stack that tries to keep the lightweight Sinatra feeling, while adding structure to an already awesome workflow.'
  s.author = 'Joris van Rooij'
  s.email = 'jorrizza@jrrzz.net'
  s.bindir = 'bin'
  s.executables = ['sinatra-mvc']
  s.default_executable = 'sinatra-mvc'
  .add_dependency('bundler',  '~> 1.0')
end