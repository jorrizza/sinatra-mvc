spec = Gem::Specification.new do |s|
  s.name = 'sinatra-mvc'
  s.version = '0.1'
  s.summary = 'MVC stack on top of Sinatra'
  s.platform = Gem::Platform::RUBY
  s.description = 'A custom MVC stack that tries to keep the lightweight Sinatra feeling, while adding structure to an already awesome workflow.'
  s.author = 'Joris van Rooij'
  s.email = 'jorrizza@jrrzz.net'
  s.homepage = 'http://www.jrrzz.net/sinatra-mvc/'
  s.bindir = 'bin'
  s.executables = %w[sinatra-mvc sinatra-mvc-project]
  s.default_executable = 'sinatra-mvc'
  s.add_dependency('bundler',  '~> 1.0')
  s.add_dependency('sinatra', '>= 1.1')
  s.add_dependency('tilt')
  s.add_dependency('sinatra-r18n')
  s.add_dependency('rack-flash')
  s.add_dependency('sinatra-redirect-with-flash')
  s.add_dependency('erubis')
  s.add_dependency('dm-core')
  s.add_dependency('dm-types')
  s.add_dependency('dm-validations')
  s.add_dependency('dm-mysql-adapter')
  s.add_dependency('dm-postgres-adapter')
  s.add_dependency('dm-sqlite-adapter')
  s.add_dependency('memcache-client')

  s.files = %w[
  bin
  bin/sinatra-mvc
  lib
  lib/sinatra-mvc
  lib/sinatra-mvc/escaping.rb
  lib/sinatra-mvc/load_utils.rb
  lib/sinatra-mvc/render_params.rb
  lib/sinatra-mvc/database_connection.rb
  lib/sinatra-mvc/load_app.rb
  lib/sinatra-mvc/post_handler.rb
  lib/sinatra-mvc/flash_messages.rb
  lib/sinatra-mvc/session_store.rb
  lib/sinatra-mvc/view_prefix.rb
  lib/sinatra-mvc/settings.rb
  lib/sinatra-mvc/conditional_form_field.rb
  lib/sinatra-mvc.rb
  skel
  skel/app
  skel/app/not_found.rb
  skel/app/index.rb
  skel/i18n
  skel/i18n/en.yml
  skel/conf
  skel/conf/settings.yml
  skel/conf/environment.rb
  skel/views
  skel/views/docs.md
  skel/views/layout.erubis
  skel/views/index.erubis
  skel/views/not_found.erubis
  skel/views/flash_message.erubis
  skel/utils
  skel/utils/upgradedb.rb
  skel/utils/initdb.rb
  skel/config.ru
  skel/models
  skel/models/.dir
  skel/public
  skel/public/.dir
  skel/Gemfile
  LICENSE
  README.md
  ]
end
