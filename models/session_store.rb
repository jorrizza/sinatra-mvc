# Database storage for the HTTP session.

class SessionStore
  include DataMapper::Resource
  
  property :session_key, String, :key => true
  property :values, Object
  property :access_time, DateTime
end
