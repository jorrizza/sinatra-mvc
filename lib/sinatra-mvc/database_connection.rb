require 'dm-core'
require 'dm-types'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-tags'
require 'dm-timestamps'
require 'dm-is-tree'
require 'dm-is-list'

# Add translations to models
require 'r18n-core/translated'

# When we're developing, some DataMapper debug would be nice.
if development?
  DataMapper::Logger.new $stdout, :debug
  #DataMapper::Model.raise_on_save_failure = true
end

# Set up our database connection.
DataMapper.setup :default, Settings.settings['database_connection']
