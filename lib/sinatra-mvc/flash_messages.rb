# Flash messages on redirect.
# See https://github.com/vast/sinatra-redirect-with-flash

require 'rack-flash'
require 'sinatra/redirect_with_flash'

class SinatraMVC
  use Rack::Flash
  register Sinatra::RedirectWithFlash
end
