require 'dm-core'
require 'dm-types'
require 'dm-validations'
require 'dm-aggregates'

# Add translations to models
require 'r18n-core/translated'

# Optional custom DataMapper plugins
#require 'dm-is-tree'
#require 'dm-is-list'

# When we're developing, some DataMapper debug would be nice.
if development?
  DataMapper::Logger.new $stdout, :debug
  #DataMapper::Model.raise_on_save_failure = true
end

# Set up our database connection.
DataMapper.setup :default, $database_connection
