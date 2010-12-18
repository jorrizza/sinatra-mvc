# Rackup file for Sinatra-MVC

::RACKUP = true
::PROJECT = File.expand_path(File.dirname(__FILE__))
Dir.chdir ::PROJECT do
  require 'sinatra-mvc'
  run Sinatra::Application
end
