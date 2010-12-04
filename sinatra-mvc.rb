#!/usr/bin/env ruby1.9.1
#
# Sinatra MVC Web Application
# Based on Sinatra and Common Sense (tm)
# 
# Joris van Rooij <jorrizza@jrrzz.net>
# http://www.jrrzz.net/
#

Encoding.default_external = 'UTF-8'

# Project include path.
$:.push File.dirname(__FILE__)

# Guess what. We need these.
require 'rubygems'
require 'sinatra'
require 'erubis'

# i18n using R18n
require 'sinatra/r18n'

# Load all of the core modules, in order.
require 'conf/settings'
require 'core/view_prefix'
require 'core/render_params'
require 'core/database_connection'
require 'core/session_store'
require 'core/flash_messages'
require 'core/post_handler'
require 'core/load_app'
require 'core/load_utils'
require 'core/conditional_form_field'
require 'core/escaping'
