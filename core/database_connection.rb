require 'dm-core'
require 'dm-types'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-is-tree'
require 'dm-is-list'

# When we're developing, some DataMapper debug would be nice.
if development?
  DataMapper::Logger.new $stdout, :debug
  #DataMapper::Model.raise_on_save_failure = true
end

# Set up our database connection.
DataMapper.setup :default, $database_connection
