# Uogrades the database if asked to.
require 'dm-migrations'

DataMapper.auto_upgrade!
