# Sessions
# Max age of sessions in seconds
set :session_max_age, 86400
# The session backend (:cookie or :memcache)
set :session_backend, :memcache
# The session store (String or array of strings for memcache servers)
# Ignored for cookie cache.
set :session_store, 'localhot:11211'

# Views
# We need the default root to reconfigure :views in certain controllers.
set :views_root, File.join(File.dirname(__FILE__), '..', 'views')

# i18n
set :default_locale, 'en'
set :translations, File.join(File.dirname(__FILE__), '..', 'i18n')

# The database connection. See DataMapper.setup docs for details.
# Since Sinatra settings are only available in request context,
# we have to define a global here. Eww.
$database_connection = 'mysql://sinatra:sinatra@localhost/sinatra_mvc'
