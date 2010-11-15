# Provides a messaging service using the session.
# You might use it for telling the user she sucks at providing input, for instance.

require 'rack-flash'
use Rack::Flash

helpers do
  # If it's called without text, it will return an array with the active messages,
  # for that type. The active messages for that type will then be cleared.
  # If it's called with :format, "text", text will be added to the messages of :format.
  # You can use :info and :error types.
  def after_post_message(type, text = nil)
    raise ArgumentError unless [:info, :error].include? type

    flash[:info] ||= []
    flash[:error] ||= []
     
    if text
      flash[type] << text
    else
      ret = flash[type].dup
      flash[type] = []
      ret
    end
  end
end
