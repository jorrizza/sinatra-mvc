class SinatraMVC
  # Sessions for Sinatra
  # Both cookie based as Memcache based sessions are supported
  case settings.session_backend
  when :cookie
    secret = (0..50).map do
      (65 + rand(25)).chr
    end.join
    use Rack::Session::Cookie, :expire_after => settings.session_max_age, :key => 'sinatra.mvc.session', :secret => secret
  when :memcache
    use Rack::Session::Memcache, :expire_after => settings.session_max_age, :key => 'sinatra.mvc.session', :namespace => 'sinatra:mvc:session', :memcache_server => settings.session_store
  else
    raise 'Unknown session backend: ' + settings.session_backend.inspect
  end
end
