# These DataMapper parts are required by Sinatra MVC.
require 'dm-core'
require 'dm-types'
require 'dm-validations'

# Add translations to models.
require 'r18n-core/translated'

class SinatraMVC
  # When we're developing, some DataMapper debug would be nice.
  if development?
    DataMapper::Logger.new $stdout, :debug
    #DataMapper::Model.raise_on_save_failure = true
  end
end

# Set up our database connection.
DataMapper.setup :default, SinatraMVC::Settings.settings['database_connection']
