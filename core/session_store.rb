# This little thing bootstraps the Sinatra session in order to
# provide a session key for a session store backend.

# The RFC 4122 compliant Ruby gem.
require 'uuidtools'

session_store = nil

configure do
  enable :sessions
end

before do
  # Generate a unique session key, which will serve as the
  # key for our session store.
  unless session[:key]
    session[:key] = UUIDTools::UUID.random_create.to_s
  end
  
  # Load the proper session from the database.
  session_store = SessionStore.get session[:key]
  unless session_store
    session_store = SessionStore.new(:session_key => session[:key],
                                     :values => {})
  end
  
  # Update the time stamp of our session, to keep it from
  # expiring.
  session_store.access_time = Time.now
  session_store.save

  # Create our global session variable. Very PHP-like.
  # I know, but just 'session' is already taken. At least it's
  # not in capital.
  # $_session = session_store.values.dup doesn't work, because
  # it'll just duplicate references. This hack works as a recursive
  # dup.
  $_session = Marshal.load(Marshal.dump session_store.values)
end

after do
  # We can't write to our session!
  raise 'Session store not initialized! Have you run initdb?' if session_store.nil?

  # Write our session back to the database.
  session_store.values = $_session
  session_store.save
  
  # Remove every session which has expired.
  SessionStore.all(:access_time.lte => Time.now - settings.session_max_age).destroy!
end
