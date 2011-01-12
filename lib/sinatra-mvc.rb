# Sinatra MVC Web Application
# Based on Sinatra and Common Sense (tm)
# 
# Joris van Rooij <jorrizza@jrrzz.net>
# http://www.jrrzz.net/

# Check if we've got a PROJECT defined.
raise RuntimeError, 'PROJECT is not defined!' unless defined? PROJECT

# A hack for now, but at least it's better than nothing.
Encoding.default_external = 'UTF-8'

# Project include path.
$:.push PROJECT

# Guess what. We need these.
require 'rubygems'
require 'sinatra/base'

# Load all of the core modules, in order.
require 'sinatra-mvc/base'
require 'sinatra-mvc/i18n'
require 'sinatra-mvc/settings'
require 'sinatra-mvc/environment_helpers'
require 'sinatra-mvc/view_prefix'
require 'sinatra-mvc/render_params'
require 'sinatra-mvc/database_connection'
require 'sinatra-mvc/session_store'
require 'sinatra-mvc/flash_messages'
require 'sinatra-mvc/post_handler'
require 'sinatra-mvc/conditional_form_field'
require 'sinatra-mvc/escaping'

# We use Bundler to manage the rest of the deps.
require 'bundler/setup'

# Load the application.
require 'conf/environment'
require 'sinatra-mvc/load_app'
require 'sinatra-mvc/load_utils'
